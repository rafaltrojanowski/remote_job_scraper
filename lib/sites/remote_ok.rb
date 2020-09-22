require_relative 'base'

module Sites
  class RemoteOk < Base

    HOST = 'https://remoteok.io'.freeze
    PATH = '/remote-dev-jobs'.freeze
    JOB_ITEM_SELECTOR = 'tr.job'.freeze
    STORE_DIR = 'data/remote_ok'.freeze

    def initialize
      super
    end

    def collect_jobs(limit: nil, keywords: nil)
      super do |csv, link|
        return if limit == @rows_count

        job_url = "#{HOST}#{link["data-url"]}"
        puts "[Info] Parsing #{job_url}..."

        csv << get_row(job_url, keywords)

        @rows_count += 1
      end
    end

    private

    def get_row(job_url, keywords)
      job_page = Nokogiri::HTML(open_page(job_url))
      offer_text = job_page.css('td.heading').to_s

      location = Support::OfferParser.get_location(offer_text)
      keywords = Support::OfferParser.get_keywords(offer_text, keywords)
      company = job_page.css('a.companyLink h3').text

      [job_url, location, keywords, company]
    end

    def get_jobs_count
      jobs_count = doc.css(JOB_ITEM_SELECTOR).map { |link| link['data-url'] }.size
      puts "[Info] There are #{jobs_count} remote jobs on [RemoteOK]."
      jobs_count
    end
  end
end
