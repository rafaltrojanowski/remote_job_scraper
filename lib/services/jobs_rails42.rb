module Services
  class JobsRails42 < Base

    # @TODO/NOTE: There is pagination on this site, it would be cool to find a way
    # to grab more offers than just first page (25 items)

    # I had to rename this class because we are not allowed to have numbers
    # on the beginning of the class name (42JobsRails won't work).

    HOST = 'https://www.42jobs.io'.freeze
    PROGRAMMING = '/rails/jobs-remote'.freeze
    JOB_ITEM_SELECTOR = 'li.job-offers__item a'.freeze
    STORE_DIR = 'data/jobs_rails42'.freeze

    def initialize(args = {})
      super(args = {})
    end

    def collect_jobs
      puts "[Info] Getting the data from #{url} at #{@current_time}..."
      FileUtils.mkdir_p STORE_DIR

      CSV.open(file_name, 'w') do |csv|
        doc.css(JOB_ITEM_SELECTOR).each do |link|
          job_url = "#{HOST}#{link["href"]}"
          puts "[Info] Processing #{job_url}..."
          job_page = Nokogiri::HTML(open_page(job_url))
          offer_text = job_page.css('.job-offer__description').to_s

          location = Support::OfferParser.get_location(offer_text)
          region   = nil
          keywords = Support::OfferParser.get_keywords(offer_text)

          csv << [job_url, location, region, keywords]
        end
      end

      puts "[Done] Collected #{@count} job offers from #{url}. Data stores in: #{file_name}."
    end

    private

    def get_count
      count = doc.css(JOB_ITEM_SELECTOR).map { |link| link['href'] }.size
      puts "[Info] There is #{count} remote jobs available."
      count
    end
  end
end
