module Citygram
  module Routes
    class Home < Base
      configure do
        set :root, File.expand_path('../../../', __FILE__)
        set :views, 'app/views'
      end

      register Sinatra::AssetPack

      assets do
        serve '/js',     from: 'public/js'
        serve '/css',    from: 'public/css'
        serve '/img',    from: 'public/img'

        js :app, [
          '/js/scripts.js',
        ]

        css :app, [
          '/css/styles.css',
         ]

        js_compression :uglify
        css_compression :simple
      end

      get '/' do
        @publishers = Publisher.all
        erb :index
      end
    end
  end
end
