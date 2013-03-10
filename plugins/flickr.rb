require "flickraw"
require "builder"

class FlickrRawAuth

  def self.getSecret(key)
    passwordLine = `/usr/bin/security 2>&1 >/dev/null find-generic-password -ga #{key}`
    if passwordLine =~ /^password: "([^"]+)"/
      return $1
    else
      raise 'Could not find secret for Flickr API key' 
    end
  end

  def self.getCredentials
    if FlickRaw.shared_secret.nil?
      FlickRaw.api_key        = 'c2380b5846d972cb12e8e37645f01bfe'
      FlickRaw.shared_secret  = self.getSecret(FlickRaw.api_key)
    end
  end

end

class FlickrPhoto

  def initialize(id, src, params)
    @id = id
    @src = src
    @size = params['size'] || 's'

    if params['title'].nil? or params['title'].empty?
      @title = "Flickr photo at @src"
    else 
      @title = params['title']
    end

    unless params['class'].nil? or params['class'].empty?
      @klass = params['class']
    end

    if params['desc'].nil? or params['desc'].empty?
      @desc = ""
    else
      @desc = params['desc']
    end

    unless params['width'].nil? or (params['width'].is_a? String and params['width'].empty?)
      @width = params['width']
    end
    unless params['height'].nil? or (params['height'].is_a? String and params['height'].empty?)
      @height = params['height']
    end
    
    unless params['gallery_id'].nil? or params['gallery_id'].empty?
      @gallery_id = params['gallery_id']
    end

    unless params['page_url'].nil? or params['page_url'].empty?
      @page_url = params['page_url']
    end

    unless params['zoom_src'].nil? or params['zoom_src'].empty?
      @zoom_src = params['zoom_src']
      unless params['zoom_width'].nil? or (params['zoom_width'].is_a? String and params['zoom_width'].empty?)
        @zoom_width = params['zoom_width']
      end
      unless params['zoom_height'].nil? or (params['zoom_height'].is_a? String and params['zoom_height'].empty?)
        @zoom_height = params['zoom_height']
      end
    end

  end

  def toHtml

    imgAttrs = {src: @src, title: @title}
    unless @klass.nil? or @klass.empty?
      imgAttrs[:class] = @klass
    end
    cssAttrs = {};
    unless @width.nil?
      cssAttrs['width'] = @width;
    end
    unless @height.nil?
      cssAttrs['height'] = @height;
    end
    imgAttrs["style"] = cssAttrs.map { |(k, v)|
      k.to_s + ': ' + v.to_s + '; '
    }.join " "

    xmlBuffer = ""
    x = Builder::XmlMarkup.new( :target => xmlBuffer )

  
    dataTitleId = 'flickr-photo-' + @id 

    anchorAttrs = {
      'href' => @zoom_src,
      'class' => 'fancybox',
      'data-title-id' => dataTitleId
    }
    captionAttrs = {
      'id' => dataTitleId
    }

    x.figure{ |x| 
      x.a(anchorAttrs) { |x|
        x.img(imgAttrs)
      }
      x.figcaption(captionAttrs) { |x|
        if @page_url.nil?
          x.h5(@title)
        else
          x.h5{ |x|
            x.a( @title, { 'class' => 'flickr-link', 'href' => @page_url })
          }
          unless @desc.nil?
            x.span( @desc, { 'class' => 'flickr-desc' } )
          end
        end
      }
    }
   
    xmlBuffer
  end
end

class FlickrSizes 
  @@sizes = {
    "s" => "Square",
    "q" => "Large Square",
    "t" => "Thumbnail",
    "m" => "Small",
    "n" => "Small 320",
    "__NONE__" => "Medium",
    "z" => "Medium 640",
    # "c" => "Medium 800",  # FlickrRaw doesn't know about this size
    "b" => "Large",
    "o" => "Original"
  }
  def self.sizes
    @@sizes
  end
end

class FlickrImage < Liquid::Tag
  @@zoom_size = 'z'

  def initialize(tag_name, markup, tokens)
    FlickrRawAuth.getCredentials()
    super
    args = markup.split(" ")
    @id   = args[0]
    @size = args[1] || 'm'
    @klass = args[2]
    @desc = args[3]

    unless FlickrSizes.sizes.keys.include? @size
      raise "did not recognize photo size for s: #{@size}";
    end

    # @src = FlickRaw.send('url_' + @size)
    info = flickr.photos.getInfo(photo_id: @id)
    @title = info['title']
    if @desc.nil? or @desc.empty?
      @desc = info['description']
    end

    # get the dimensions
    sizes = flickr.photos.getSizes(photo_id: @id);
    @src, @width, @height = self.class.getSourceAndDimensionsForSize(sizes, @size)
    @zoomSrc, @zoomWidth, @zoomHeight = self.class.getSourceAndDimensionsForSize(sizes, @@zoom_size)
  end

  def self.getSourceAndDimensionsForSize(sizes, size)
    # n.b. within this class method, 'self' is the class
    sizeInfo = self.pickSize(sizes, size)
    if (sizeInfo.nil?) 
      sizeInfo = pickSize(sizes, 'o')
      if (sizeInfo.nil?)
        raise "could not get a size"
      end
    end
    [ sizeInfo["source"], sizeInfo["width"], sizeInfo["height"] ]
  end

  def self.pickSize(sizes, desiredSize)
    desiredSizeLabel = FlickrSizes.sizes[desiredSize]
    sizes.select{ |item| item["label"] == desiredSizeLabel }[0]
  end

  def render(context)
    FlickrPhoto.new(@id, @src, {
      "title" => @title, 
      "width" => @width, 
      "height" => @height, 
      "class" => @klass, 
      "desc" => @desc,
      "zoom_src" => @zoomSrc, 
      "zoom_width" => @zoomWidth, 
      "zoom_height" => @zoomHeight
    }).toHtml
  end

end

class FlickrSet < Liquid::Tag
  # these are the sizes we can get in the photosets extra info

  def initialize(tag_name, markup, tokens)
    FlickrRawAuth.getCredentials()
    super
    @markup = markup
    @id   = markup.split(" ")[0]
    @size = markup.split(" ")[1] || 'm'

    unless FlickrSizes.sizes.keys.include? @size
      raise "did not recognize photo size for sets: #{@size}";
    end
  end

  def render(context)
    info = flickr.photosets.getInfo(photoset_id: @id)
    
    outputHtml = []

    # assume the title is in the blog post title?
    # titleHtml = '<p>' + info.title + '</p>'
    # outputHtml.push(titleHtml)
    
    unless info.description.empty?
      outputHtml.push('<p>' + info.description + '</p>')
    end

    setPhotosHtml = [];
    # pathalias will give us pretty urls to the photo page
    # note, you have to request 'path_alias' but the returned prop is "pathalias"
    apiExtras = ['url_' + @size, 'path_alias'].join(',');
    response = flickr.photosets.getPhotos(photoset_id: @id, extras: apiExtras)
    response['photo'].each do |photo|
      src = photo["url_" + @size]
      params = {
        "width" => photo["width_" + @size],
        "height" => photo["height_" + @size],
        "title" => photo["title"],
        # this doesn't call the api, it constructs the URL from info retrieved
        "page_url" => FlickRaw.url_photopage(photo)
      }
      photoInfoResponse = flickr.photos.getInfo(photo_id: photo["id"])
      params["desc"] = photoInfoResponse["description"] 
      setPhotosHtml.push(FlickrPhoto.new(photo["id"], src, params).toHtml)
    end

    setHtml = '<p class="flickr-set">' + setPhotosHtml.join + '</p>'
    outputHtml.push(setHtml)

    outputHtml.join
  end

end

Liquid::Template.register_tag("flickr_image", FlickrImage)
Liquid::Template.register_tag("flickr_set", FlickrSet)
