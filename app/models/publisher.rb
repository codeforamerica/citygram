module Georelevent
  module Models
    class Publisher < Sequel::Model
      set_allowed_columns :title, :endpoint
    end
  end
end
