require './spec/spec_helper'
require './lib/daisy'

describe Daisy::Configuration do
  it :init do
    Daisy::Configuration.init('./test_data/config/daisy.yml')
  end
end
