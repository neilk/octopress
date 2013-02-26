require "flickraw"
require "singleton"
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
  def initialize(id, size='m', desc=nil, meta=nil)
    @id = id
    @size = size || 'm'
    @desc = desc
    @meta = meta
  end

  def toHtml

    output = []
    # Basic info
    info = flickr.photos.getInfo(photo_id: @id)
    
    title         = info["title"]
    description   = info["description"]

    src           = FlickRaw.send("url_#{@size}", info)
    page_url      = FlickRaw.url_photopage(info)

    img_tag       = "<img src=\"#{src}\" title=\"#{title}\"/>"
    output[0]     = "<a href=\"#{page_url}\">#{img_tag}</a>"
    
    output[1]     = "<p>#{description}</p>" if @desc == "y"
    
    if @meta == "y"
      # EXIF
      exif          = flickr.photos.getExif(photo_id: @id)
      camera        = exif["camera"]
    
      f_number, exposure_time, iso, focal_length = ""

      exif["exif"].each do |exif_line|
        f_number =  exif_line["clean"] if exif_line["tag"] == "FNumber"
        exposure_time = exif_line["clean"] if exif_line["tag"] == "ExposureTime"
        iso = exif_line["raw"] if exif_line["tag"] == "ISO"
        focal_length = exif_line["clean"] if exif_line["tag"] == "FocalLength"
      end
    
      exif_table = "<table class=\"flickr-exif\">
        <tr>
          <td>Camera</td>
          <td>#{camera}</td>
        </tr>
        <tr>
          <td>Exposure</td>
          <td>#{exposure_time}</td>
        </tr>
        <tr>
          <td>Aperture</td>
          <td>#{f_number}</td>
        </tr>
        <tr>
          <td>Focal Length</td>
          <td>#{focal_length}</td>
        </tr>
        <tr>
          <td>ISO</td>
          <td>#{iso}</td>
        </tr>
      </table>".gsub("\n", "")
    
      output[2] = exif_table
    end
    
    # Build output
    output.join
  end
end


class FlickrImage < Liquid::Tag
  def initialize(tag_name, markup, tokens)
    FlickrRawAuth.getCredentials()
    super
    args = markup.split(" ")
    @id   = args[0]
    @size = args[1]
    @desc = args[2]
    @meta = args[3]
  end

  def render(context)
    FlickrPhoto.new(@id, @size, @desc, @meta).toHtml
  end

end


class FlickrSet < Liquid::Tag
  def initialize(tag_name, markup, tokens)
    FlickrRawAuth.getCredentials()
    super
    @markup = markup
    @id   = markup.split(" ")[0]
    @size = markup.split(" ")[1]
  end

  def render(context)
    output = []

    info = flickr.photosets.getInfo(photoset_id: @id)
    title = info.title
    description = info.description

    output.push(title)
    output.push(description)

    response = flickr.photosets.getPhotos(photoset_id: @id)
    response['photo'].each do |photo|
      output.push(FlickrPhoto.new(photo.id, @size).toHtml)
    end

    output.join
  end

end

Liquid::Template.register_tag("flickr_image", FlickrImage)
Liquid::Template.register_tag("flickr_set", FlickrSet)
