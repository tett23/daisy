require "daisy/version"
require 'daisy/configuration'
require 'daisy/storage'
require 'daisy/storages'
require 'active_support/all'
require 'hashie'

module Daisy
  extend self

  def write(path)
    raise 'file not exist' unless File.exist?(path)
    write_size = File.size(path)

    storage = Daisy::Storages.items.shuffle.find do |item|
      item.writable?(write_size: write_size)
    end
    raise WritableStrageNotFoundError if storage.nil?

    storage.write(path)
  end

  def writable?(path)

  end

  def exist?(item_name)
    Daisy::Storages.items.shuffle.select do |item|
      item.readable?
    end.any? do |item|
      item.exist?(item_name)
    end
  end

  def find(item_name)
    storage = Daisy::Storages.items.shuffle.select do |item|
      item.readable?
    end.find do |item|
      item.exist?(item_name)
    end
    return nil if storage.nil?


    storage.path(item_name)
  end

  def path(item_name)
  end

  class QuotaError < StandardError; end
  class WriteError < IOError; end
  class WritableStrageNotFoundError < StandardError; end
  class FileNotFound < StandardError; end
end
