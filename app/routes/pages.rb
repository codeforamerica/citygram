require 'sinatra/content_for'

module Citygram::Routes
  class Pages < Citygram::App
    helpers Sinatra::ContentFor

    get '/' do
      @cities = City.all
      erb :index, layout: :'splash-layout'
    end

    get '/:tag' do
      @city = City.find(params[:tag])
      @publishers = Publisher.active.visible.tagged(@city.id)
      erb :show
    end
  end
end
