require "builder"
require "flickraw"
require "memoize"

# CAUTION: This entire plugin is an XSS vector, as we accept HTML from the Flickr API and
# republish it without any transformation or sanitization on our site. If someone can control
# the HTML in titles or descriptions on Flickr they can inject arbitrary HTML into our site.
# The risk is relatively low, since Flickr goes to great lengths to sanitize their inputs. But
# an attacker could exploit some difference between the two sites (encoding, maybe) to do XSS.

class FlickrCache
  def self.cacheFile(name)
    cache_folder     = File.expand_path "../.flickr-cache", File.dirname(__FILE__)
    FileUtils.mkdir_p cache_folder
    return "#{cache_folder}/#{name}"
  end
end

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
  @@zoom_size = 'z'

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

    # get the dimensions
    sizes = flickr.photos.getSizes(photo_id: @id)
    @src, @width, @height = FlickrSizes.getSourceAndDimensionsForSize(sizes, @size)
    @zoomSrc, @zoomWidth, @zoomHeight = FlickrSizes.getSourceAndDimensionsForSize(sizes, @@zoom_size)
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
      'href' => @zoomSrc,
      'class' => 'fancybox',
      'data-title-id' => dataTitleId
    }
    if @gallery_id
      anchorAttrs['rel'] = @gallery_id;
    end
    captionAttrs = {
      'id' => dataTitleId
    }

    x.figure( {'class' => 'flickr-thumbnail'} ) { |x| 
      x.a(anchorAttrs) { |x|
        x.img(imgAttrs)
      }
      x.figcaption(captionAttrs) { |x|
        # append title and desc, unescaped, because they are already escaped, and can contain HTML
        if @page_url.nil?
          x.h5{ |x| x << @title}  
        else
          x.h5{ |x|
            x.a('class' => 'flickr-link', 'href' => @page_url) { |x| x << @title }
          }
        end
        x << @desc
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
    desiredSizeLabel = @@sizes[desiredSize]
    sizes.select{ |item| item["label"] == desiredSizeLabel }[0]
  end

end

class FlickrImage < Liquid::Tag
  include Memoize

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
    
    memoize(:getHtml, FlickrCache.cacheFile("image"))
  end

  def render(context)
    self.getHtml(@id, @size, @klass, @desc)
  end

  def getHtml(id, size, klass, desc)
    # @src = FlickRaw.send('url_' + @size)
    info = flickr.photos.getInfo(photo_id: id)
    page_url = FlickRaw.url_photopage(info)
    title = info['title']
    if @desc.nil? or @desc.empty?
      @desc = info['description']
    end

    FlickrPhoto.new(@id, @src, {
      "page_url" => page_url, 
      "title" => title, 
      "width" => @width, 
      "height" => @height, 
      "class" => @klass, 
      "desc" => @desc,
      "size" => @size
    }).toHtml
  end

end

class FlickrSet < Liquid::Tag
  include Memoize

  def initialize(tag_name, markup, tokens)
    super
    args = markup.split(" ")
    @id = args[0]
    @size = args[1] || 'm'
    @showSetDesc = true
    if (args[2] == 'nodesc')
      @showSetDesc = false 
    end

    unless FlickrSizes.sizes.keys.include? @size
      raise "did not recognize photo size for sets: #{@size}";
    end

    memoize(:getHtml, FlickrCache.cacheFile("set"))
  end

  def render(context)
    getHtml(@id, @size, @showSetDesc)
  end

  def getHtml(id, size, showSetDesc)
    FlickrRawAuth.getCredentials()
    info = flickr.photosets.getInfo(photoset_id: id)
    
    outputHtml = []

    # assume the title is in the blog post title?
    # titleHtml = '<p>' + info.title + '</p>'
    # outputHtml.push(titleHtml)
    
    if showSetDesc and not info.description.empty?
      outputHtml.push('<p>' + info.description + '</p>')
    end

    setPhotosHtml = [];
    # pathalias will give us pretty urls to the photo page
    # note, you have to request 'path_alias' but the returned prop is "pathalias"
    apiExtras = ['url_' + size, 'path_alias'].join(',');
    response = flickr.photosets.getPhotos(photoset_id: id, extras: apiExtras)
    response['photo'].each do |photo|
      src = photo["url_" + size]
      params = {
        "size" => size,
        "width" => photo["width_" + size],
        "height" => photo["height_" + size],
        "title" => photo["title"],
        # this doesn't call the api, it constructs the URL from info retrieved
        "page_url" => FlickRaw.url_photopage(photo),
        "gallery_id" => "flickr-set-" + id
      }
      photoInfoResponse = flickr.photos.getInfo(photo_id: photo["id"])
      params["desc"] = photoInfoResponse["description"] 
      setPhotosHtml.push(FlickrPhoto.new(photo["id"], src, params).toHtml)
    end

    setHtml = '<section class="flickr-set">' + setPhotosHtml.join + '</section>'
    outputHtml.push(setHtml)

    outputHtml.join
  end
  

end

Liquid::Template.register_tag("flickr_image", FlickrImage)
Liquid::Template.register_tag("flickr_set", FlickrSet)
