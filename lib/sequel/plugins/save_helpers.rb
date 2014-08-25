# https://github.com/maccman/monocle/blob/f329a22f5e615cada0feda658e044d5fe0884319/lib/sequel/save_helpers.rb
module Sequel::Plugins
  module SaveHelpers
    module ClassMethods
      def create!(*args, &block)
        new(*args, &block).save!
      end
    end

    module InstanceMethods
      def save!(*columns)
        opts = columns.last.is_a?(Hash) ? columns.pop : {}
        opts.merge!(raise_on_failure: true)
        save(*columns, opts)
      end
    end
  end
end
