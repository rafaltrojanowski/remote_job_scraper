require 'remote_job_scraper/version'

require 'services/we_work_remotely'
require 'services/remote_ok'
require 'services/jobs_rails42'

require 'support/offer_parser'
require 'support/user_agent'
require 'support/spreadsheet_creator'

require 'nokogiri'
require 'open-uri'
require 'csv'
require "thor"

module RemoteJobScraper

  AVAILABLE_SERVICES = %w(we_work_remotely remote_ok 42jobs_rails)

  class CLI < Thor

    desc 'collect_jobs', 'Retrieves data from all services'
    def collect_jobs
      [Services::WeWorkRemotely, Services::RemoteOk].each do |klass|
        klass.new.collect_jobs
      end
    end

    desc 'collect_jobs_from', 'Retrieves data from specified service'
    def collect_jobs_from(service_name)
      case service_name
      when 'we_work_remotely'
        then Services::WeWorkRemotely.new.collect_jobs
      when 'remote_ok'
        then Services::RemoteOk.new.collect_jobs
      when '42jobs_rails'
        then Services::JobsRails42.new.collect_jobs
      else
        raise "#{service_name} is not correct. Use: #{AVAILABLE_SERVICES.join(', ')}."
      end
    end

    desc 'generate_summary', 'Collect all data and export to XLS file'
    def generate_summary
      Support::SpreadsheetCreator.generate
    end

    desc 'clean_up', 'Removes all stored data'
    def clean_up
      puts "This command will remote all stored data."
      puts "Press Ctrl-C to abort."

      sleep 2

      FileUtils.rm_rf('data')
      puts "Removed data."
    end

  end

  def self.root
    File.dirname __dir__
  end
end
