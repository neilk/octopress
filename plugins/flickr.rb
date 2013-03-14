require "builder"
require "cgi"
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

class FlickrPhotoHtml
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
    # Including width and height helps with a certain webkit rendering bug when laying out
    # lots of inline-block items. But explicit width and height causes large images to scale improperly at
    # small device widths.
    # So, we include width and height only for smallish images, less than iPhone 3 width minus some padding.
    # Using 450 because it's 480 (iPhone 3 width) with some padding
    if (not (@width.nil?)) and @width.to_i < 450
      cssAttrs['width'] = @width.to_s + 'px';
      unless @height.nil?
        cssAttrs['height'] = @height.to_s + 'px';
      end
      imgAttrs["style"] = cssAttrs.map { |(k, v)|
        k.to_s + ': ' + v.to_s + ';'
      }.join " "
    end

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

class FlickrVideoHtml
  @@type="application/x-shockwave-flash" 
  @@playerSwf="http://www.flickr.com/apps/video/stewart.swf?v=109786" 
  @@classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
  @@bgcolor="#000000" 
  @@allowfullscreen="true" 
  @@size = '__video__'

  def initialize(id, photoSecret, size, origWidth, origHeight)
    @id = id
    @photoSecret = photoSecret
    @size = size
    @origWidth = origWidth
    @origHeight = origHeight
  end

  def toHtml
    width, height = FlickrSizes.calculateDimensions(@size, @origWidth, @origHeight)

    flashvarsHash = {
      intl_lang: 'en-us',
      photo_secret: @photoSecret,
      photo_id: @id
    }
    flashvars = flashvarsHash.map { | (k, v) | 
      CGI.escape(k.to_s) + '=' + CGI.escape(v.to_s)
    }.join "&"

    xmlBuffer = ""
    x = Builder::XmlMarkup.new( :target => xmlBuffer )

    x.object( { 'type' => @@type, 
                'width' => width, 
                'height' => height,
                'data' => @@playerSwf,
                'classid' => @@classid } ) { |x|
      x.param( { 'name' => 'flashvars', 'value' => flashvars } )
      x.param( { 'name' => 'movie', 'value' => @@playerSwf } )
      x.param( { 'name' => 'bgcolor', 'value' => @@bgcolor } )
      x.param( { 'name' => 'allowFullScreen', 'value' => @@allowfullscreen } )
      x.embed( { 'type' => @@type, 
                 'src' => @@playerSwf, 
                 'bgcolor' => @@bgcolor,
                 'allowfullscreen' => @@allowfullscreen,
                 'flashvars' => flashvars,
                 'width' => width,
                 'height' => height } )
    }

    xmlBuffer
  end
end


class FlickrSizes 
  @@sizes = {
    "s" => { label: "Square", max: 75 },
    "q" => { label: "Large Square", max: 150 },
    "t" => { label: "Thumbnail", max: 100 },
    "m" => { label: "Small", max: 240 },
    "n" => { label: "Small 320", max: 320 },
    "__NONE__" => { label: "Medium", max: 500 },
    "z" => { label: "Medium 640", max: 640 },
    # "c" => { label: "Medium 800", max: 75 },  # FlickrRaw doesn't know about this size
    "b" => { label: "Large", max: 1024 },
    "o" => { label: "Original", max: nil }
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
    desiredSizeLabel = @@sizes[desiredSize][:label]
    sizes.select{ |item| item["label"] == desiredSizeLabel }[0]
  end

  def self.calculateDimensions(desiredSize, width, height)
    width = width.to_i
    height = height.to_i
    size = @@sizes[desiredSize]
    factor = 1
    unless size == nil or size[:max].nil?
      factor = size[:max].to_f / [width, height].max
    end
    return [width, height].map { |dim| (dim * factor).to_i }
  end
end

class FlickrImageTag < Liquid::Tag
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
    
    memoize(:getHtml, FlickrCache.cacheFile("photo"))
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
    
    html = "HTML should go here"
    if info['video']
      secret = info['video']['secret']
      width = info['video']['width']
      height = info['video']['height']
      html = FlickrVideoHtml.new(@id, secret, @size, width, height).toHtml
    else 
      html = FlickrPhotoHtml.new(@id, @src, {
        "page_url" => page_url, 
        "title" => title, 
        "class" => @klass, 
        "desc" => @desc,
        "size" => @size
      }).toHtml
    end
  
    html
  end

end

class FlickrSetTag < Liquid::Tag
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
      setPhotosHtml.push(FlickrPhotoHtml.new(photo["id"], src, params).toHtml)
    end

    setHtml = '<section class="flickr-set">' + setPhotosHtml.join + '</section>'
    outputHtml.push(setHtml)

    outputHtml.join
  end
  

end

Liquid::Template.register_tag("flickr_image", FlickrImageTag)
Liquid::Template.register_tag("flickr_set", FlickrSetTag)
