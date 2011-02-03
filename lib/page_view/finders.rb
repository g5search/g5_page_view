module G5PageView
  module Finders
    def first(document={})
      self.collection.find(document).first
    end
  end  
end
