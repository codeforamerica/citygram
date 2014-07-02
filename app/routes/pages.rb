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

      get '/' do
        erb :index
      end
    end
  end
end
