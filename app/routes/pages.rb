module Citygram::Routes
  class Pages < Citygram::App
    get '/' do
      @cities = City.all.select do |city|
        Publisher.active.visible.tagged(city.id).any?
      end

      erb :index, layout: false
    end

    get '/:tag' do
      @city = City.find(params[:tag])
      @publishers = Publisher.active.visible.tagged(@city.id)
      erb :show
    end
  end
end
