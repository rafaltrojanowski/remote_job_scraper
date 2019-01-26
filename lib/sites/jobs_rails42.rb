module Sites
  class JobsRails42 < Base

    # @TODO/NOTE: There is pagination on this site, it would be cool to find a way
    # to grab more offers than just first page (25 items)

    # I had to rename this class because we are not allowed to have numbers
    # on the beginning of the class name (42JobsRails won't work).

    HOST = 'https://www.42jobs.io'.freeze
    PROGRAMMING = '/rails/jobs-remote'.freeze
    JOB_ITEM_SELECTOR = 'li.job-offers__item a'.freeze
    STORE_DIR = 'data/jobs_rails42'.freeze

    def initialize(job_type: :programming, total_pages: 4)
      @job_type = job_type
      @url = build_url
      @doc = nil
      @current_time = Time.new
      @timestamp = @current_time.strftime("%Y%m%d%H%M%S")
      @total_pages = total_pages
      @count = get_count
    end

    def collect_jobs
      (1..@total_pages).to_a.each do |page|
        current_page = "#{@url}?page=#{page}"
        doc = Nokogiri::HTML(open_page(current_page))
        process_page(doc, current_page, page)
      end
    end

    private

    def process_page(doc, page_url, page)
      puts "[Info] Getting the data from #{page_url} at #{@current_time}..."
      FileUtils.mkdir_p STORE_DIR

      CSV.open(filepath, 'ab') do |csv|
        doc.css(JOB_ITEM_SELECTOR).each do |link|
          job_url = "#{HOST}#{link["href"]}"
          puts "[Info] Processing #{job_url}..."
          job_page = Nokogiri::HTML(open_page(job_url))
          offer_text = job_page.css('.job-offer__description').to_s

          location = Support::OfferParser.get_location(offer_text)
          keywords = Support::OfferParser.get_keywords(offer_text)

          csv << [job_url, location, keywords]
        end
      end

      puts "[Done] Collected #{@count} job offers from #{url}. Data stores in: #{filepath}." if page == @total_pages
    end

    private

    def get_count
      25 * @total_pages
    end
  end
end
