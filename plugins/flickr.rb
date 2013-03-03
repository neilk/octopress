require "flickraw"
# require "debugger"

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
  def initialize(src, params)
    @src = src
    @size = params['size'] || 's'

    unless params['title'].nil? or params['title'].empty?
      @title = params['title']
    end

    unless params['class'].nil? or params['class'].empty?
      @klass = params['class']
    end
    unless params['desc'].nil? or params['desc'].empty?
      @desc = params['desc']
    end
    unless params['width'].nil? or (params['width'].is_a? String and params['width'].empty?)
      @width = params['width']
    end
    unless params['height'].nil? or (params['height'].is_a? String and params['height'].empty?)
      @height = params['height']
    end
    
    unless params['page_url'].nil? or params['page_url'].empty?
      @page_url = params['page_url']
    end
  end

  def toHtml

    output = []

    # TODO use a real HTML builder here - Nokogiri?
    klassAttr = '';
    unless @klass.nil? or @klass.empty?
      klassAttr = "class=\"#{@klass}\""
    end

    cssAttrs = {};
    unless @width.nil?
      cssAttrs['width'] = @width;
    end
    unless @height.nil?
      cssAttrs['height'] = @height;
    end
    styleAttr = cssAttrs.map { |(k, v)|
      k.to_s + '="' + v.to_s + '"'
    }.join " "

    img_tag       = "<img src=\"#{@src}\" title=\"#{@title}\" #{klassAttr} #{styleAttr} />"
    output[0]     = "<a href=\"#{@page_url}\">#{img_tag}</a>"
    
    # description?
    # output[1]     = "<p>#{description}</p>" if @desc == "y"
    
    # Build output
    output.join
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
    "c" => "Medium 800",
    "b" => "Large",
    "o" => "Original"
  }
  def self.sizes
    @@sizes
  end
end

class FlickrImage < Liquid::Tag
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
    desiredSizeLabel = FlickrSizes.sizes[@size]
    sizes = flickr.photos.getSizes(photo_id: @id);
    desiredSize = sizes.select{ |item| item["label"] == desiredSizeLabel }[0]
    @src = desiredSize["source"]
    @width = desiredSize["width"]
    @height = desiredSize["height"]
  end

  def render(context)
    FlickrPhoto.new(@src, {"title" => @title, "width" => @width, "height" => @height, "class" => @klass, "desc" => @desc}).toHtml
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
      # get description?
      setPhotosHtml.push(FlickrPhoto.new(src, params).toHtml)
    end

    setHtml = '<p class="flickr-set">' + setPhotosHtml.join + '</p>'
    outputHtml.push(setHtml)

    outputHtml.join
  end

end

Liquid::Template.register_tag("flickr_image", FlickrImage)
Liquid::Template.register_tag("flickr_set", FlickrSet)
