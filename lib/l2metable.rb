require "l2metable/version"

module L2Metable 

  # Descendants should override and implement a specific component prefix for all log lines
  # e.g. "widget#{subcomponent}"
  #
  def log_component(subcomponent)
    subcomponent
  end

  # Descendants should override and implement a specific base hash for all log lines, if applicable
  # e.g. {:app_id => @app_id, :xid => context.xid}
  #
  def log_base_hash()
    {}
  end

  # Descendants should override and implement a specific log handler
  # e.g. @logger.write(full_msg)
  #
  def log_write(msg)
    puts msg
  end

  def monitor(subcomponent, extras = {}, &blk)
    unless block_given?
      # should never enter, but logging with something obvious instead of blowing up at runtime
      measure(dotted(subcomponent, "MONITOR_WITHOUT_BLOCK"), 1, extras)
      return
    end

    start = Time.now
    measure(dotted(subcomponent, "start"), 1, extras)

    res = nil
    ex = nil
    begin
      res = yield
    rescue => e
      log_exception(subcomponent, e, extras)
      ex = e
    end

    measure(dotted(subcomponent, "time"), Time.now - start, extras)

    if ex
      raise(ex)
    else
      res
    end
  end

  def measure(subcomponent, value, extras = {})
    comp = log_component(subcomponent)
    log_hash({("measure#"+ comp) => value}.merge(extras))
  end

  def sample(subcomponent, value, extras = {})
    comp = log_component(subcomponent)
    log_hash({("sample#"+ comp) => value}.merge(extras))
  end

  def count(subcomponent, value=1, extras ={})
    comp = log_component(subcomponent)
    log_hash({("count#"+ comp) => value}.merge(extras))
  end

  def log_exception(subcomponent, e, extras = {})
    exception_suffix = "exception"
    extras = {:at => dotted(log_component(subcomponent), exception_suffix)}.merge(extras)

    if e.nil? || !e.is_a?(Exception)
      measure(exception_suffix, 1, extras)
      return
    end

    exception_id = e.object_id.abs
    trace = e.backtrace.reduce do |memo, line|
      memo + line.gsub(/[`'"]/, "") + "\n"
    end
    measure(exception_suffix, 1, {
      :exception_id => exception_id,
      :class => e.class,
      :message => e.message,
      :trace => trace
    }.merge(extras))
  end

  def join_hash(hash = {})
    hash.map do |k, v|
      if v.is_a? Float
        # workaround for old Ruby version on Bamboo not having parameterized round()
        v = (v * 1000).round() / 1000.0
      elsif v.to_s =~ /\s/
        v = "\"#{v}\""
      end
      "#{k}=#{v}"
    end.join(" ")
  end

  def log_hash(hash = {})
    log_write(join_hash(log_base_hash.merge(hash)))
  end

  def dotted(*pieces)
    (pieces.reject { |e| e.nil? || (e.respond_to?('empty?') && e.empty?) }).join('.')
  end
end
