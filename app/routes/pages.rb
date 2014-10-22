module Citygram::Routes
  class Pages < Citygram::App
    get '/' do
      @publishers = Publisher.visible
      erb :index, layout: :'splash-layout'
    end
  end
end
