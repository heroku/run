module Run
  module Util
    extend self

    def deny?(flag)
      not Dir["DENY", "DENY_#{flag.upcase}"].empty?
    end

  end
end
