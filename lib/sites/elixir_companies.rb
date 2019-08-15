require_relative 'base'

module Sites
  class ElixirCompanies < Base

    HOST = 'https://elixir-companies.com'.freeze
    PATH = '/en/browse'.freeze
    JOB_ITEM_SELECTOR = 'div.company.box'.freeze
    STORE_DIR = 'data/elixir_companies'.freeze

    def initialize
      @url = "#{self.class::HOST}#{self.class::PATH}"
      @current_time = Time.now
      @timestamp = @current_time.strftime("%Y%m%d%H%M%S")
      @doc = nil
      @total_pages = 26
      @rows_count = 0
      @jobs_count = get_jobs_count
    end

    def collect_companies(limit: nil)
      FileUtils.mkdir_p STORE_DIR

      (1..@total_pages).each do |page|
        process_page(page: page, limit: limit)
      end
    end

    def companies_count
      @rows_count
    end

    private

    def process_page(page:, limit:)
      current_page = "#{@url}?page=#{page}"
      doc = Nokogiri::HTML(open_page(current_page))
      puts "[Info] Getting the data from #{current_page}"

      CSV.open(filepath, 'ab') do |csv|
        doc.css(JOB_ITEM_SELECTOR).each do |company_box|
          return if limit == @rows_count
          csv << get_row(company_box)
          @rows_count += 1
        end
      end

      puts "[Done] Collected #{@jobs_count} job offers from #{url}. Data stored in: #{filepath}." if page == @total_pages
    end

    def get_row(company_box)
      company_title = company_box.css('div.content p.title').text
      company_info  = company_box.css('div.content.company-info p')

      # A bit ugly way to get a data between span elements
      array = company_info.text.split("\n").select do |element|
        element =~ /[a-zA-Z]/
      end.map!(&:strip).delete_if do |element|
        element == "GitHub" || element == "Add a job"
      end

      has_blog = array[2] && (array[2].include?("/") || array[2].include?("blog"))

      industry = array[0]
      company_website = array[1]
      is_hiring = company_box["class"].include?("has-ribbon")

      if has_blog
        blog = array[2]
        location = array[4]
      else
        blog = nil
        location = array[2]
      end

      row = [company_title, industry, company_website, blog, location]
      hiring = is_hiring ? "Hiring!" : nil
      row.push hiring
    end

    def get_jobs_count
      jobs_count = 16 * @total_pages # roughly - first page has 14 items
      puts "[Info] There are #{jobs_count} remote jobs on [ElixirCompanies]."
      jobs_count
    end
  end
end
