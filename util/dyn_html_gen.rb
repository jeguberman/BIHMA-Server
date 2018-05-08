def generateIndex
  begin
    home = Dir.pwd
    sputs "bfwr".magenta
    sputs WEB_ROOT.magenta
    # sputs WEB_ROOT.class.magenta
    Dir.chdir WEB_ROOT
    sputs "afwe".magenta
  rescue Exception => e
    sputs e.exception.red
    sputs e.message.red
  end

  here = '<!DOCTYPE html>
  <html lang="en" dir="ltr">
    <head>
      <meta charset="utf-8">
      <title>index</title>
    </head>
    <body>
      <h1>This is the index.</h1>
      <div class="">
        <a href="hello.html">hello world</a>
        <a href="speechless.png" download>one punch man</a>

        <ul class="list">'

    Dir.glob("*.zip").each do |filename|
      if !File.directory? filename
        here += "<li><a href='#{filename}' download>#{filename}</a></li>"
      end
    end

    here += '      </ul>
        </div>
      </body>
    </html>'

    responseHeader = "HTTP/1.1 200 OK\r\n" +
    "Content-Type: text/html\r\n" +
    "Content-Length: #{here.bytesize}\r\n" +
    "Connection: close\r\n"

    Dir.chdir home
    sputs "end".magenta
    return responseHeader, here

end
