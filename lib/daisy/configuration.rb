require 'yaml'

module Daisy
  class Configuration
    class << self

      def init(config_path=nil)
        config = YAML.load_file(config_path)
        @config = Hashie::Mash.new(config)
      end

      def method_missing(name, *_)
        raise '' if @config.nil?

        @config.public_send(name, nil)
      end

      def exists?(name)
      end
    end
  end
end
