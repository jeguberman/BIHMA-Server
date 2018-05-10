require 'set'

def render_html(options={})
  home = Dir.pwd
  Dir.chdir WEB_ROOT
  params = {
    title: "500 Internal Server Error",
    banner: "Internal Server Error",
    message: ""
  }.merge(options)


  header = <<-HTML
    <head>
      <meta charset='utf-8'>
      <title>#{params[:title]}</title>
    </head>
  HTML


  body = <<-HTML
    <body>
      <h1>#{params[:banner]}</h1>
      <p>#{params[:message]}</p>
      <hr>
      <ul class='files'>
        #{generateFileList(params[:title])}
      </ul>
    </body>
  HTML

  html = <<-HTML
  <!DOCTYPE html>
    <html lang='en' dir='ltr'>
      #{header}
      #{body}
    </html>
  HTML

  Dir.chdir home
  return html
end

def generateFileList(title)
  if title != "index"
    return nil
  end
  list = ""
begin
  Dir.glob("*").each do |filename|
    if !File.directory? filename
      next if filename == "log"
      list += "<li>
        <a href='#{filename}' download>#{filename}</a>
      </li>
      "
    end
  end
rescue
  sputs "", error:true
end

  return list
end




#this ended up not being used, but I believe I can use it in the future to organize the list of files by extension. I would also like to have an option to merely view the files instead of downloading them, which shouldn't prove too hard, except for the videos, which I believe will require decoding.

# FORMATS = {
#   png: :image
#   jpg: :image
#   jpeg: :image
#   gif: :image
#   tff: :image
#   bmp: :image
#   pdf: :image
#
#   mov: :video
#   avi: :video
#   flv: :video
#   wmv: :video
#   mov: :video
#   mkv: :video
#   ogg: :video
#
#   mp3: :audio
#   wav: :audio
#   flac: :audio
#
#   doc: :text
#   docx: :text
#   html: :text
#   css: :text
#   js: :text
# } #for organizing the layout of the html, not for http headers. In the future I would like to combine these tables. see https://www.iana.org/assignments/media-types/media-types.xhtml#text and https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types and https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type
