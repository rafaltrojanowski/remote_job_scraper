require 'remote_job_scraper/version'
require 'remote_job_scraper/configuration'
require 'remote_job_scraper/cli'

require 'sites/we_work_remotely'
require 'sites/remote_ok'
require 'sites/jobs_rails42'

require 'support/offer_parser'
require 'support/user_agent'
require 'support/spreadsheet_creator'

require 'nokogiri'
require 'open-uri'
require 'csv'

module RemoteJobScraper

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.root
    File.dirname __dir__
  end
end
