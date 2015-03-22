require './spec/spec_helper'
require './lib/daisy'

describe Daisy::Storages do
  before :all do
    Daisy::Configuration.init('./test_data/config/daisy.yml')
  end

  it :items do
    config = Hashie::Mash.new(YAML.load_file('./test_data/config/daisy.yml'))
    expect(Daisy::Storages.items.map do |storage|
      storage.name
    end.sort).to match_array(config.storages.map do |storage|
      storage.name
    end)
  end
end
