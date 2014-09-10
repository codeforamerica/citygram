module FixtureHelpers
  POINT_IN_POLYGON = OpenStruct.new(
    polygon: '{"type":"Polygon","coordinates":[[[100.0,20.0],[101.0,20.0],[101.0,21.0],[100.0,21.0],[100.0,20.0]]]}',
    point: '{"type":"Point","coordinates":[100.5,20.5]}',
    excluded_point: '{"type":"Point","coordinates":[0.0,0.0]}'
  )

  def fixture(name)
    File.read("spec/support/fixtures/#{name}")
  end
end

RSpec.configure do |config|
  config.include FixtureHelpers
end
