module Citygram::Routes
  class Pages < Citygram::App
    get '/*' do
      redirect 'https://www.citygram.org/lexington'
    end
  end
end
