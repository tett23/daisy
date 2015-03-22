require './spec/spec_helper'
require './lib/daisy'

describe Daisy::Storage do
  before :all do
    @storage = Daisy::Storage .new(name: 'daisy_test', mount_point: './tmp', quota: {size: 1, unit: :percentage})
  end

  it :size do
    @storage.size
  end

  it :free do
    @storage.free
  end

  it :out_of_quota? do
    @storage.out_of_quota?
  end
end
