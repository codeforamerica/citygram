module Citygram
  module Routes
    class Pages < Sinatra::Application
      configure do
        set :root, File.expand_path('../../../', __FILE__)
        set :views, 'app/views'

        disable :method_override
        disable :protection
        disable :static

        set :erb, escape_html: true,
                  layout_options: { views: 'app/views/layouts' }

        enable :use_code
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
        erb :index
      end
    end
  end
end
