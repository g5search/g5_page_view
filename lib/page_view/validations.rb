module G5PageView
  module Validations
    def validate_required!
      required_fields.each do |r| 
        unless (self[r] || self[r.to_s])
          raise Exceptions::MissingFields.new(required_fields, self.to_s) 
        end
      end      
    end
  end
end
  