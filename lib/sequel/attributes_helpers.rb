# Sequel::Model#values does not invoke deserializers
module Sequel
  module Plugins
    module AttributesHelpers
      module InstanceMethods
        def allowed_attributes
          self.class.allowed_columns.reduce({}) do |res, attribute|
            res[attribute] = self.public_send(attribute)
            res
          end
        end

        def attributes
          self.class.columns.reduce({}) do |res, attribute|
            res[attribute] = self.public_send(attribute)
            res
          end
        end
      end
    end
  end
end
