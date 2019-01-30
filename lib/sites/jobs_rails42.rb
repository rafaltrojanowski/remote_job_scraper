module Sites
  class JobsRails42 < Base

    # @NOTE: I had to rename this class because we are not allowed to have numbers
    # on the beginning of the class name (42JobsRails won't work).
    # file paths follow this convention

    HOST = 'https://www.42jobs.io'.freeze
    PATH = '/rails/jobs-remote'.freeze
    JOB_ITEM_SELECTOR = 'li.job-offers__item a'.freeze
    STORE_DIR = 'data/jobs_rails42'.freeze

    def initialize
      @url = "#{self.class::HOST}#{self.class::PATH}"
      @current_time = Time.now
      @timestamp = @current_time.strftime("%Y%m%d%H%M%S")
      @doc = nil
      @total_pages = 4
      @rows_count = 0
      @jobs_count = get_jobs_count
    end

    def collect_jobs(limit: nil)
      FileUtils.mkdir_p STORE_DIR

      (1..@total_pages).each do |page|
        process_page(page: page, limit: limit)
      end
    end

    private

    def process_page(page:, limit:)
      current_page = "#{@url}?page=#{page}"
      doc = Nokogiri::HTML(open_page(current_page))
      puts "[Info] Getting the data from #{current_page}"

      CSV.open(filepath, 'ab') do |csv|
        doc.css(JOB_ITEM_SELECTOR).each do |link|
          return if limit == @rows_count

          job_url = "#{HOST}#{link["href"]}"
          puts "[Info] Parsing #{job_url}..."

          csv << get_row(job_url)

          @rows_count += 1
        end
      end

      puts "[Done] Collected #{@jobs_count} job offers from #{url}. Data stored in: #{filepath}." if page == @total_pages
    end

    def get_row(job_url)
      job_page = Nokogiri::HTML(open_page(job_url))
      offer_text = job_page.css('.job-offer__description').to_s

      location = Support::OfferParser.get_location(offer_text)
      keywords = Support::OfferParser.get_keywords(offer_text)
      company = job_page.css('.job-offer__summary a').text

      [job_url, location, keywords, company]
    end

    def get_jobs_count
      jobs_count = 25 * @total_pages
      puts "[Info] There are #{jobs_count} remote jobs on [42JobsRails]."
      jobs_count
    end
  end
end
