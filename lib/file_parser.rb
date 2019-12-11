# frozen_string_literal: true

class FileParser
  private_class_method :new

  MISSING_FILE = 'File is missing!'
  INVALID_FILE = 'File not found!'

  def initialize(args)
    @log_file = input_files(args)
  end

  class << self
    def call(*args)
      new(*args).read_file
    end
  end

  def read_file
    return puts MISSING_FILE if log_file.nil?
    return puts INVALID_FILE unless File.file?(log_file)

    formatted_results
  end

  private

  attr_accessor :log_file

  def input_files(files)
    files ? files[0] : nil
  end

  def formatted_results
    puts '==== Most viewed urls: ===='
    most_viewed

    puts

    puts '==== Most unique visits ===='
    most_unique_visits
  end

  def file_parse
    @file_parse ||= Hash.new { |h, k| h[k] = [] }.tap do |objects|
      File.open(log_file).each do |line|
        url, ip = line.split(' ')
        objects[url] << ip
      end
    end
  end

  def most_viewed
    file_parse.sort_by { |_, v| v.count }
              .reverse!
              .map { |url, ip| p "Url: #{url.ljust(20)} Visits: #{ip.count}" }
  end

  def most_unique_visits
    file_parse.sort_by { |_, v| v.uniq.size }
              .reverse!
              .map { |url, ip| p "Url: #{url.ljust(20)} Unique visits: #{ip.uniq.size}" }
  end
end
