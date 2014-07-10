module Citygram
  module Routes
    module Validations
      class Max < Grape::Validations::SingleOptionValidator
        def validate_param!(attr_name, params)
          unless params[attr_name].to_i <= @option
            raise Grape::Exceptions::Validation, param: @scope.full_name(attr_name), message: "must be less than #{@option}"
          end
        end
      end
    end
  end
end
