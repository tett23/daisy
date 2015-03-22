require 'fileutils'
require 'sys/filesystem'
require 'digest/sha1'

module Daisy
  class Storage
    def initialize(config)
      config.deep_symbolize_keys!

      @name = config[:name]
      @mount_point = config[:mount_point]
      case config[:quota][:unit].to_sym
      when :bytes
        @quota = config[:quota][:size].to_f
      when :percentage
        @quota = (size * config[:quota][:size].to_f).floor
      end
    end
    attr_reader :name, :mount_point, :quota

    def write(file)
      raise FileNotFound unless File.exist?(file)
      raise WriteError unless writable?(write_size: File.size(file))

      out_path = path(file)
      FileUtils.mkdir_p(File.dirname(out_path)) unless Dir.exist?(File.dirname(out_path))
      FileUtils.mv(file, out_path)
    end

    def alive?
      FileUtils.touch('daisy_alive_test')
      FileUtils.rm('daisy_alive_test')
    end

    def permissions
      File.stat(@mount_point)
    end

    def stat
      File.stat(@mount_point)
    end

    def readable?
      stat.readable?
    end

    def writable?(write_size: nil)
      return false if out_of_quota?
      return false unless stat.writable?
      return true if write_size.nil?
      return false  if out_of_quota?(write_size: write_size)

      return true
    end

    def executable?
      stat.executable?
    end

    def out_of_quota?(write_size: nil)
      if write_size.nil?
        free <= @quota
      else
        (free - write_size) <= @quota
      end
    end

    def size(suffix: false)
      stat = Sys::Filesystem.stat(@mount_point)
      size = (stat.blocks * stat.block_size)

      if suffix
        size.to_s(:human_size)
      else
        size
      end
    end

    def free(suffix: false)
      stat = Sys::Filesystem.stat(@mount_point)
      available_size = (stat.blocks_available * stat.block_size)

      if suffix
        available_size.to_s(:human_size)
      else
        available_size
      end
    end

    def exist?(name, fizzy: false)
      File.exist?(path(name))
    end

    def path(name)
      File.join(@mount_point, Storage.output_dir(name), File.basename(name))
    end

    class << self
      def output_dir(name)
        filename_hash(File.basename(name)).split(//).each_slice(2).first(2).map do |char|
          char.join()
        end.join(File::SEPARATOR)
      end

      def filename_hash(name)
        Digest::SHA1.hexdigest(File.basename(name))
      end
    end
  end
end
