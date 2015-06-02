module Citygram::Routes
  class Page < Citygram::App
    get '/' do
      @city = City.find(ENV.fetch('ROOT_CITY_TAG', nil))
      @publishers = Publisher.active.visible.tagged(@city.id)
      erb :show
    end

    get '/:tag' do
      redirect '/'
    end
  end
end
