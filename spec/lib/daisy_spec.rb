require './spec/spec_helper'
require './lib/daisy'

describe Daisy do
  it :write do
    FileUtils.touch('./test_data/test_files/foo')
    Daisy.write('./test_data/test_files/foo')
    Daisy.exist?('foo')
    Daisy.find('foo')
  end
end
