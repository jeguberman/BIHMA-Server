require 'thread'

@dibs = Mutex.new

  THREAD_IDS={ Thread.current => "main"}
  @thread_count = 0

  def add_thread_id
    # sputs "adding thread (~#{@thread_count + 1}) to THREAD_IDS", "yellow"
    @dibs.synchronize do
      @thread_count +=1
      THREAD_IDS[Thread.current]=@thread_count
    end
    # sputs "added thread to THREAD_IDS", "green"
  end

  def remove_thread_id
    # sputs "removing thread from THREAD_IDS", "yellow"
    tid = threadID
    @dibs.synchronize do
      THREAD_IDS.delete(Thread.current)
    end
    # sputs "removed thread (#{tid}) from THREAD_IDS", "green"
  end

  def threadID
    if THREAD_IDS[Thread.current]
      return THREAD_IDS[Thread.current]
    else
      return "?"
    end
  end
