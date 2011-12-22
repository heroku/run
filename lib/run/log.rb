module Run
  module Log
    extend self

    def info(*data, &blk)
      data = format_data(data)
      message = "file=#{file} fun=#{fun} #{data}"
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
      trace = format_trace(e.backtrace)
      $stdout.puts "class=#{e.class} message=`#{e.message}' trace=#{trace[0, trace.size-4]}"
    end

    private

    def fun
      caller[2].match(/([^` ]*)'/) && $1.strip
    end

    def file
      caller[1].match(/#{Dir.getwd}\/lib\/([^\.]*)/) && $1.strip
    end

    def format_data(data)
      data.map do |i|
        case i
        when Hash
          i.map do |k, v|
            case v
            when Hash
              "#{k}=#"
            else
              "#{k}=#{v.to_s}"
              end
          end.join(" ")
        else
          i.to_s
        end
      end.join(" ")
    end

    def format_trace(trace)
      trace.map do |i|
        i.match(/(#{Gem.dir}|#{Dir.getwd})\/(.*)/) && $2.strip
      end
    end

  end
end
