module Daisy
  class Storages
    class << self
      def items
        Daisy::Configuration.storages.map do |storage|
          Storage.new(storage.to_h)
        end
      end

      def find(item)
        items.find do |storage|
          storage.exist?(item)
        end
      end
    end
  end
end
