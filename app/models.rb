require 'lib/save_helpers'
Sequel::Model.plugin Sequel::Plugins::SaveHelpers

module Georelevent
  module Models
  end
end

require 'app/models/event'
require 'app/models/subscription'
