# Sequel::Model#values does not invoke deserializers
module Sequel
  module Plugins
    module AttributesHelpers
      module InstanceMethods
        def attributes
          self.class.columns.reduce({}) do |res, attribute|
            res[attribute] = self.public_send(attribute)
            res
          end
        end

        def allowed_attributes
          attributes.select { |k,_| self.class.allowed_columns.include?(k) }
        end
      end
    end
  end
end
