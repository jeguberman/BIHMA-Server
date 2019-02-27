$GLOBALS = {
  feedback: false,
  path: "samples"
}

#globals should only be set at start up, before any multi-threading occurs. While they can be accessed from different threads, they shouldn't be mutatable from different threads, so I am not using a mutex lock here.

#path must be set with a slash at argv, like this "/MyDocuments"

#2019-01-24: oh my god what was I doing, there was a preinstalled
#https://ruby-doc.org/stdlib-2.2.3/libdoc/getoptlong/rdoc/GetoptLong.html
#class https://stackoverflow.com/questions/5688685/how-to-use-getoptlong-class-in-ruby

#how is this a global variable? Why isn't this it's own class file? Why is this a class? Does this need to be a class? I feel like ruby is only happy when something is a class.

class OptionsHandler

  def self.set_globals_from_argv
    ARGV.each_with_index do |arg, ix|
      case arg.slice(0)
      when "-"
        handle_flags(arg)
      when "/"
        set_custom_path(arg)
      else
        raise ArgumentError, "Bad argument \"#{arg}\" passed from command line"
      end
    end
  end

  def self.set_custom_path(path)
    if File.directory?(Dir.home + path)
      $GLOBALS[:path] = Dir.home + path
    elsif File.directory?( path)
      $GLOBALS[:path] = path
    else
      raise ArgumentError, "No directory found at given path"
    end
  end

  def self.handle_flags(arg)
    if arg.slice(1) != "-"
      handle_short_flags(arg)
    else
      handle_full_flag(arg)
    end
  end

  def self.handle_short_flags(arg)
    shortflags = {
      "p" => :path,
      "f" => :feedback
    }
    arg = arg.split(//)
    arg.shift
    arg.each do |flag|
      arg = shortflags[flag]
      handle_full_flag(arg)
    end
  end

  def self.handle_full_flag(arg)
    $GLOBALS[arg] = !$GLOBALS[arg]
  end

end
