require "flickraw"
require "debugger"

class FlickrImage < Liquid::Tag
  def initialize(tag_name, markup, tokens)
     super
     @markup = markup
     @id   = markup.split(" ")[0]
     @size = markup.split(" ")[1]
     @desc = markup.split(" ")[2]
     @meta = markup.split(" ")[3]
  end

  def render(context)
    FlickRaw.api_key        = ENV["FLICKR_KEY"]
    FlickRaw.shared_secret  = ENV["FLICKR_SECRET"]
    
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

Liquid::Template.register_tag("flickr_image", FlickrImage)
