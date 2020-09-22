module Sites
  class Base

    attr_reader :doc, :url, :rows_count, :jobs_count

    def initialize
      @url = "#{self.class::HOST}#{self.class::PATH}"
      @doc = Nokogiri::HTML(open_page(@url))
      @current_time = Time.now
      @timestamp = @current_time.strftime("%Y%m%d%H%M%S")
      @rows_count = 0
      @jobs_count = get_jobs_count
    end

    def collect_jobs(limit: nil, keywords: nil)
      puts "[Info] Getting the data from #{url}"
      FileUtils.mkdir_p self.class::STORE_DIR

      CSV.open(filepath, 'w') do |csv|
        doc.css(self.class::JOB_ITEM_SELECTOR).each do |link|
          yield(csv, link)
        end
      end

      puts "[Done] Collected #{@rows_count} job offers from #{url}. Data stored in: #{filepath}."
    end

    private

    def open_page(url)
      sleep(rand(delay_range)) unless ENV['RAILS_ENV'] == 'test' # less mechanical behaviour
      options = ENV['RAILS_ENV'] == 'test' ? {} : { 'User-Agent' => user_agent }
      URI.open(url, options)
    end

    def delay_range
      RemoteJobScraper.configuration.delay_range
    end

    def user_agent
      Support::UserAgent::LIST.sample
    end

    def filepath
      return test_filepath if ENV["RAILS_ENV"] == 'test'
      "#{self.class::STORE_DIR}/#{@timestamp}.csv"
    end

    def test_filepath
      "spec/fixtures/data/#{underscore(self.class.name.split('::').last)}/#{@timestamp}.csv"
    end

    # https://stackoverflow.com/a/5622585
    def underscore(camel_cased_word)
      word = camel_cased_word.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end
  end
end
