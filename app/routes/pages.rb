module Citygram::Routes
  class Pages < Citygram::App
    get '/' do
      @publishers = Publisher.active
      erb :index
    end
  end
end
