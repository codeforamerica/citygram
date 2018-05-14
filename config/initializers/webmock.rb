# Travis build failure workaround
 
if Rails.env.test?
  require 'webmock'
  WebMock.disable_net_connect!(allow_localhost: true)
end