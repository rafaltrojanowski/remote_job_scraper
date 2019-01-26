require 'remote_job_scraper/version'

require 'sites/we_work_remotely'
require 'sites/remote_ok'
require 'sites/jobs_rails42'

require 'support/offer_parser'
require 'support/user_agent'
require 'support/spreadsheet_creator'

require 'nokogiri'
require 'open-uri'
require 'csv'
require "thor"

module RemoteJobScraper

  AVAILABLE_SITES = %w(we_work_remotely remote_ok 42jobs_rails)

  class CLI < Thor

    desc 'collect_jobs', "Retrieves data from #{AVAILABLE_SITES.join(', ')}"
    def collect_jobs
      [Sites::WeWorkRemotely, Sites::RemoteOk].each do |klass|
        klass.new.collect_jobs
      end
    end

    desc 'collect_jobs_from SITE', "Retrieves data from SITE, e.g. #{AVAILABLE_SITES.sample}"
    def collect_jobs_from(site)
      case site
      when 'we_work_remotely'
        then Sites::WeWorkRemotely.new.collect_jobs
      when 'remote_ok'
        then Sites::RemoteOk.new.collect_jobs
      when '42jobs_rails'
        then Sites::JobsRails42.new.collect_jobs
      else
        raise "#{site} is not correct. Use: #{AVAILABLE_SITES.join(', ')}."
      end
    end

    desc 'generate_summary', "Merges data from #{AVAILABLE_SITES.join(', ')} and exports to XLS file"
    def generate_summary
      Support::SpreadsheetCreator.generate
    end

    desc 'remove DIRNAME', "Removes DIRNAME (default: 'data'). Use carefully."
    def remove(dirname = 'data')
      puts "[Warning!]"
      puts "This command will remove #{Dir.pwd}/#{dirname} permanently"
      puts "Press Ctrl-C to abort."

      sleep 3

      FileUtils.rm_rf(dirname)
      puts "Removed data in #{Dir.pwd}/#{dirname}."
    end
  end

  def self.root
    File.dirname __dir__
  end
end
