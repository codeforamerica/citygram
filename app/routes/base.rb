module Citygram
  module Routes
    class Base < Sinatra::Application
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
    end
  end
end
