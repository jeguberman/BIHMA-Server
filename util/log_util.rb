HISTORY=Hash.new { |h, k| h[k] = [] }
@i=0


def sputs(string, options={}) #puts string to sterr stream with color for aided visibility
  # debugger
  params = {
    color: nil,
    important: false,
    newline: true,
    scrubLastNewline: true,
    error: false,
    indent: false,
    header: false
    }.merge(options)

    if params[:header]
      params[:newline] = true
      params[:indent] = true
    end

  begin
    tid = threadID
    string = scrubString(string, params)

    hPush(string, tid) #push into history log
    if($live_log || params[:important]) #live_log is a global flag set at execution to give more robust feedback
      string = "#{tid}: " + string
      STDERR.puts(string)
    end
    return true

  rescue Exception => e
    eString ="#{e.backtrace[0]}: #{e.message} (#{e.exception.class})\r\n".red

    STDERR.puts "sputs logged an error\r\n".black.on_red
    STDERR.puts(eString)

    # (0... e.backtrace.length).each do |frame|
    #   eString.concat "\tfrom #{e.backtrace[frame]}".red
    # end
    e.backtrace.each do |frame|
      eString.concat "\tfrom #{frame}\r\n"
    end

    hPush eString, tid
    raise e

  end
end

def scrubString(string, params)

  if params[:scrubLastNewline]
    while /[\r\n]/=~string.slice(-1)
      string = string.chop
    end
  end #this should be better, it depends on knowing the structure of the string

  if params[:indent]
    string = "\t#{string}"
    string = string.gsub(/\r\n|\r\n/,"\r\n\t")
  end

  string = string.gsub(/[\r\n]/,"") if !params[:newline]

  if params[:color]
    string = string.send("colorize",params[:color].to_sym)
  end
  return string
end



def hPush(string, tid) #format string for history log and push to history log
  e = Time.now
  msStamp = "  #{e.strftime('%6L')}  ".magenta
  hString = "#{string}#{e}"#.strftime(" @ %I:%M:%S%p")}"
  # threadStamp = "#{tid.rjust(4,'0')}"
  threadStamp = "#{tid}"
  threadStamp = threadStamp.rjust(4,'0').cyan + "  "
  threadStamp = threadStamp.cyan
  HISTORY[tid].push (msStamp + hString)
  HISTORY[:all].push (msStamp + threadStamp + hString)
end


def dumpHistory #serializes history object and writes it log
  puts "\r\nClosing from interrupt, printing log history to ./log"
  log = File.open("log","a")
  log.puts "&!\r\n"
  log.puts Time.now
  HISTORY.default = nil
  l = Marshal.dump(HISTORY)
  log.puts l
  log.puts "&!\r\n"
  log.close
end

def readHistory #unused
  HISTORY.each do |k,v|
    next if k == :all
    log.puts "#{k}:\r\n"
    v.each_with_index do |message, ix|
      log.puts "    #{ix.to_s.rjust(4,'0')}:#{message}"
    end
  end
  log.puts "order"+"  milSec  ".magenta+"thrd".cyan+"  *************************************".blue
  HISTORY[:all].each_with_index do |entry, ix|
    log.puts "#{ix.to_s.rjust(4,'0')} #{entry}"
  end

end
