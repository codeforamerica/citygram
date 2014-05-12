module Georelevent
  module Models
    class Subscription < Sequel::Model
      plugin :serialization, :geometry, :geom
    end
  end
end
