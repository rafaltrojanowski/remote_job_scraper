require_relative 'base'

module Services
  class WeWorkRemotely < Base

    HOST = 'https://weworkremotely.com'.freeze
    PROGRAMMING = '/categories/remote-programming-jobs'.freeze
    DEVOPS     = '/categories/remote-devops-sysadmin-jobs'.freeze
    JOB_ITEM_SELECTOR = '.jobs-container li a'.freeze
    STORE_DIR = 'data/we_work_remotely'

    def initialize(args)
      super(args)
    end

    def collect_jobs
      puts "Getting the data from #{url} at #{@current_time}..."
      FileUtils.mkdir_p STORE_DIR

      CSV.open(file_name, 'w') do |csv|
        doc.css(JOB_ITEM_SELECTOR).each do |link|
          if link["href"].start_with?("/remote-jobs")
            job_url = "#{HOST}#{link["href"]}"
            puts "Processing #{job_url}..."
            job_page = Nokogiri::HTML(open(job_url))
            region = job_page.css('span.region').first
            location = job_page.css('span.location').first

            csv << [job_url, location, region]
          end
        end
      end

      puts "Collected #{@count} job offers from #{url}. Data stores in: #{file_name}."
    end

    private

    def get_count
      count = doc.css(JOB_ITEM_SELECTOR)
        .map { |link| link['href'] }
        .select { |href| href.start_with?('/remote-jobs') }
        .size
      puts "There is #{count} remote jobs available."
      count
    end
  end
end
