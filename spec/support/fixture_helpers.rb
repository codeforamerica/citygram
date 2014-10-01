module FixtureHelpers
  def fixture(name)
    File.read("spec/support/fixtures/#{name}")
  end

  module_function :fixture
end
