require_relative 'base'

module Sites
  class WeWorkRemotely < Base

    HOST = 'https://weworkremotely.com'.freeze
    PATH = '/categories/remote-programming-jobs'.freeze
    DEVOPS     = '/categories/remote-devops-sysadmin-jobs'.freeze
    JOB_ITEM_SELECTOR = '.jobs-container li a'.freeze
    STORE_DIR = 'data/we_work_remotely'

    def initialize
      super
    end

    def collect_jobs
      puts "[Info] Getting the data from #{url} at #{@current_time}..."
      FileUtils.mkdir_p STORE_DIR

      CSV.open(filepath, 'w') do |csv|
        doc.css(JOB_ITEM_SELECTOR).each do |link|
          if link["href"].start_with?("/remote-jobs")
            job_url = "#{HOST}#{link["href"]}"
            puts "[Info] Processing #{job_url}..."

            csv << get_row(job_url)
          end
        end
      end

      puts "[Done] Collected #{@count} job offers from #{url}. Data stores in: #{filepath}."
    end

    private

    def get_row(job_url)
      job_page = Nokogiri::HTML(open_page(job_url))
      offer_text = job_page.css('.listing-container').to_s

      region = job_page.css('.listing-header-container span.region').first
      location = job_page.css('.listing-header-container span.location').first
      keywords = Support::OfferParser.get_keywords(offer_text)
      company = job_page.css('.listing-header-container span.company').first

      [job_url, location, region, keywords, company]
    end

    def get_count
      count = doc.css(JOB_ITEM_SELECTOR)
        .map { |link| link['href'] }
        .select { |href| href.start_with?('/remote-jobs') }
        .size
      puts "[Info] There is #{count} remote jobs available."
      count
    end
  end
end
