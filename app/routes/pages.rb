module Citygram::Routes
  class Pages < Citygram::App
    get '/' do
      @cities = []
      erb :index, layout: :'splash-layout'
    end

    get '/:tag' do
      @publishers = Publisher.active.visible.tagged(params[:tag])
      erb :show
    end
  end
end
