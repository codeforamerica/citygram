module Citygram::Routes
  class Pages < Citygram::App
    get '/' do
      @publishers = Publisher.visible
      erb :index
    end
  end
end
