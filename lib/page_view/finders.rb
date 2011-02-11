module G5PageView
  module Finders
    def first(document={})
      self.collection.find(document).limit(1).first
    end
  end  
end
