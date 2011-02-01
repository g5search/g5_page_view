module G5PageView
  module Exceptions
    class Standard < ::Exception; end
    class InvalidDocument < Standard
      def initialize(message='')
        @message=message
      end
    end
    class MissingFields < Standard
      def initialize(required=[], object=nil)
        @required= required
        @object= object
      end
      
      def message
        "Required fields #{@required} were not all set.#{ @object.inspect if @object}"
      end
    end
  end
end
