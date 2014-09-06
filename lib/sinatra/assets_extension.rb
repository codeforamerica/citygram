require 'sinatra/base'
require 'sprockets'

module Sinatra
  module AssetsExtension
    class UnknownAsset < StandardError; end

    module Helpers
      def asset_path(path)
        asset = Citygram::App.assets[path]
        raise UnknownAsset, "missing asset: #{path}" unless asset
        "/assets/#{asset.digest_path}"
      end
    end

    def self.registered(app)
      assets = Sprockets::Environment.new

      # access sprockets environment through application
      app.set :assets, assets

      # include helpers in ERB context
      assets.context_class.class_eval do
        include Sinatra::AssetsExtension::Helpers
      end

      # declare asset engines
      assets.css_compressor = :scss
      app.configure :production do
        assets.js_compressor  = :uglify
      end

      # setup asset paths
      assets.append_path('app/assets/css')
      assets.append_path('app/assets/img')
      assets.append_path('app/assets/js')

      # mixin helper methods to application
      app.helpers Sinatra::AssetsExtension::Helpers

      app.configure :development do
        require 'sprockets/cache/file_store'
        assets.cache = Sprockets::Cache::FileStore.new('./tmp')
      end
    end
  end
end
