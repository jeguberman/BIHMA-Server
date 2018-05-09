HISTORY=Hash.new { |h, k| h[k] = [] }
@i=0


def sputs(string, options={}) #puts string to sterr stream with color for aided visibility
  if string.class.ancestors.include? Exception
    handle_error(string)
    return false
  end


  string = string.to_s

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

  # begin
    tid = threadID
    tid = tid ? tid.to_s.rjust(4,"0") : "????"
    string = format_string(string, params)

    history_push(string, tid) #push into history log
    if($live_log || params[:important]) #live_log is a global flag set at execution to give more robust feedback
      string = "#{tid}/#{Thread.list.length}: " + string
      STDERR.puts(string)
    end
    return true

  # rescue Exception => e
  #   handle_error(e)
  # end
end

def handle_error(error) #takes an exception and formats error message with backtrace for stdout

    tid = threadID
    eString ="#{error.backtrace[0]}: #{error.message} (#{error.exception.class})\r\n"



    error.backtrace.each do |frame|
      eString.concat "\tfrom #{frame}\r\n"
    end
    eString = eString.red

    STDERR.puts "sputs logged an error on thread #{tid}".black.on_red
    STDERR.puts(eString)
    history_push eString, tid
    history_push "killing current thread".red, tid
    Thread.kill Thread.current
end

def format_string(string, params)

  if params[:scrubLastNewline]
    while /[\r\n]/=~string.slice(-1)
      string = string.chop
    end
  end #this should be better, it depends on knowing the structure of the string

  if params[:indent]
    string = "#{string}"
    string = string.gsub(/\r\n|\r\n/,"\r\n\t")
  end

  string = string.gsub(/[\r\n]/,"") if !params[:newline]

  if params[:color]
    string = string.send("colorize",params[:color].to_sym)
  end
  return string
end



def history_push(string, tid) #format string for history log and push to history log
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
