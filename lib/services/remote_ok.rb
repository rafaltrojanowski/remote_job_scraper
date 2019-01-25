require_relative 'base'

module Services
  class RemoteOk < Base

    HOST = 'https://remoteok.io'.freeze
    PROGRAMMING = '/remote-dev-jobs'.freeze
    JOB_ITEM_SELECTOR = 'tr.job'.freeze
    STORE_DIR = 'data/remote_ok'.freeze

    def initialize(args = {})
      super(args = {})
    end

    def collect_jobs
      puts "[Info] Getting the data from #{url} at #{@current_time}..."
      FileUtils.mkdir_p STORE_DIR

      CSV.open(filepath, 'w') do |csv|
        doc.css(JOB_ITEM_SELECTOR).each do |link|
          job_url = "#{HOST}#{link["data-url"]}"
          puts "[Info] Processing #{job_url}..."
          job_page = Nokogiri::HTML(open_page(job_url))
          offer_text = job_page.css('td.heading').to_s

          location = Support::OfferParser.get_location(offer_text)
          region   = nil
          keywords = Support::OfferParser.get_keywords(offer_text)

          csv << [job_url, location, region, keywords]
        end
      end

      puts "[Done] Collected #{@count} job offers from #{url}. Data stores in: #{filepath}."
    end

    private

    def get_count
      count = doc.css(JOB_ITEM_SELECTOR).map { |link| link['data-url'] }.size
      puts "[Info] There is #{count} remote jobs available."
      count
    end
  end
end
