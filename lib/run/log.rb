module Run
  module Log
    extend self

    def info(*data, &blk)
      data = to_data(data)
      message = "file=#{to_file} fun=#{to_fun} #{data}"
      if not blk
        $stdout.puts message
      else
        start = Time.now
        $stdout.puts "#{message} block=begin"
        result = yield
        $stdout.puts "#{message} block=finish elapsed=#{Time.now - start}"
        result
      end
    end

    def error(e)
      message = to_message(e.message)
      trace = to_trace(e.backtrace)
      $stdout.puts "class=#{e.class} message=`#{message}' trace=#{trace[0, trace.size-4]}"
    end

    private

    def to_fun
      caller[2].match(/([^` ]*)'/) && $1.strip
    end

    def to_file
      caller[1].match(/#{Dir.getwd}\/lib\/([^\.]*)/) && $1.strip
    end

    def to_data(data)
      data.map do |i|
        case i
        when Hash
          i.map do |k, v|
            case v
            when Hash
              "#{k}=#"
            when NilClass
              "#{k}=nil"
            else
              "#{k}=#{v.to_s}"
              end
          end.join(" ")
        else
          i.to_s
        end
      end.join(" ")
    end

    def to_message(message)
      message.lines.to_a.first.strip
    end

    def to_trace(trace)
      trace.map do |i|
        i.match(/(#{Gem.dir}|#{Dir.getwd})\/(.*)/) && $2.strip
      end
    end

  end
end
