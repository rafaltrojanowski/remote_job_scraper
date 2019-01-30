require "thor"

module RemoteJobScraper
  class CLI < Thor

    AVAILABLE_SITES = %w(we_work_remotely remote_ok 42jobs_rails)

    desc 'collect_jobs LIMIT DELAY',
      "Retrieves data from #{AVAILABLE_SITES.join(', ')}.
       [Example]: remote_job_scraper collect_jobs 10 9.0..10.0
      "
    def collect_jobs(limit = nil, delay = nil)
      limit = limit.to_i
      limit = limit.zero? ? nil : limit

      begin
        unless delay.nil?
          arr =  delay.split('..').map{ |d| Float(d) }
          range = arr[0]..arr[1]
          RemoteJobScraper.configuration.delay_range = range
        end
      rescue
        raise "Passed: DELAY=#{range} DELAY need to be in format: 2.0..5.0 "
      end

      [
        Sites::WeWorkRemotely,
        Sites::RemoteOk,
        Sites::JobsRails42
      ].each do |klass|
        klass.new.collect_jobs(limit: limit)
      end
    end

    desc 'collect_jobs_from SITE LIMIT',
      "Retrieves data from SITE with LIMIT, e.g. #{AVAILABLE_SITES.sample}
       [Example]: remote_job_scraper collect_jobs_from remote_ok 10
      "
    def collect_jobs_from(site, limit=nil)
      limit = limit.to_i
      limit = limit.zero? ? nil : limit

      case site
      when 'we_work_remotely'
        then Sites::WeWorkRemotely.new.collect_jobs(limit: limit)
      when 'remote_ok'
        then Sites::RemoteOk.new.collect_jobs(limit: limit)
      when '42jobs_rails'
        then Sites::JobsRails42.new.collect_jobs(limit: limit)
      else
        raise "#{site} is not correct. Use: #{AVAILABLE_SITES.join(', ')}."
      end
    end

    desc 'generate_summary',
      "Merges data from #{AVAILABLE_SITES.join(', ')} and exports to
      separate sheets in XLS file.
      "
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
end
