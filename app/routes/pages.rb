module Citygram::Routes
  class Pages < Sinatra::Base
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
        '/js/vendor/latlon.js',
        '/js/scripts.js',
      ]

      css :app, [
        '/css/styles.css',
      ]

      js_compression :uglify
      css_compression :simple
    end

    get '/' do
      @publishers = Publisher.visible
      erb :index
    end

    get '/research' do
      erb :research, layout: false
    end
  end
end
