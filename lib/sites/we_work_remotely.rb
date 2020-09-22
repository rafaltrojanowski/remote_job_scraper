require_relative 'base'

module Sites
  class WeWorkRemotely < Base

    HOST = 'https://weworkremotely.com'.freeze
    PATH = '/categories/remote-programming-jobs'.freeze
    DEVOPS     = '/categories/remote-devops-sysadmin-jobs'.freeze
    JOB_ITEM_SELECTOR = '.jobs-container li a'.freeze
    STORE_DIR = 'data/we_work_remotely'.freeze

    def initialize
      super
    end

    def collect_jobs(limit: nil, keywords: nil)
      super do |csv, link|
        if link["href"].start_with?("/remote-jobs")
          return if limit == @rows_count

          job_url = "#{HOST}#{link["href"]}"
          puts "[Info] Parsing #{job_url}..."

          csv << get_row(job_url, keywords)

          @rows_count += 1
        end
      end

      puts "[Done] Collected #{@rows_count} job offers from #{url}. Data stored in: #{filepath}."
    end

    private

    def get_row(job_url, keywords)
      job_page = Nokogiri::HTML(open_page(job_url))
      offer_text = job_page.css('.listing-container').to_s

      region = job_page.css('.listing-header-container span.region').first
      location = job_page.css('.listing-header-container span.location').first
      keywords = Support::OfferParser.get_keywords(offer_text, keywords)
      company = job_page.css('.listing-header-container span.company').first

      [job_url, location, region, keywords, company]
    end

    def get_jobs_count
      jobs_count = doc.css(JOB_ITEM_SELECTOR)
        .map { |link| link['href'] }
        .select { |href| href.start_with?('/remote-jobs') }
        .size
      puts "[Info] There are #{jobs_count} remote jobs on [WeWorkRemotely]."
      jobs_count
    end
  end
end
