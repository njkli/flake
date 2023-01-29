%w[pry awesome_print].each(&method(:require))

module Dummy
  class BB
    class << self
      def didik
        'hello'
        binding.pry
      end
    end
  end
end 

Dummy::BB.didik