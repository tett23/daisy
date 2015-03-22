module Daisy
  class Storages
    class << self
      def items
        Daisy::Configuration.storages.map do |storage|
          Storage.new(storage.to_h)
        end
      end
    end
  end
end
