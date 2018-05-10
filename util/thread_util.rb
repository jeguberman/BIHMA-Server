require 'thread'

#functions to make it easier to keep track of threads

  THREAD_IDS={ Thread.current => "main"}
  @thread_count = 0

  def add_thread_id
    # sputs "adding thread (~#{@thread_count + 1}) to THREAD_IDS", "yellow"
      @thread_count +=1
      THREAD_IDS[Thread.current]=@thread_count
    # sputs "added thread to THREAD_IDS", "green"
  end

  def remove_thread_id
    # sputs "removing thread from THREAD_IDS", "yellow"
    # tid = threadID
      THREAD_IDS.delete(Thread.current)
    # sputs "removed thread (#{tid}) from THREAD_IDS", "green"
  end

  def threadID
    if THREAD_IDS[Thread.current]
      return THREAD_IDS[Thread.current]
    else
      return nil
    end
  end
