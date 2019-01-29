module Sites
  class Base

    attr_reader :doc, :url

    def initialize
      @url = "#{self.class::HOST}#{self.class::PATH}"
      @doc = Nokogiri::HTML(open_page(@url))
      @current_time = Time.new
      @timestamp = @current_time.strftime("%Y%m%d%H%M%S")
      @count = get_count
    end

    private

    def open_page(url)
      sleep(rand(0..2.0)) unless ENV['RAILS_ENV'] == 'test' # less mechanical behaviour
      options = ENV['RAILS_ENV'] == 'test' ? {} : { 'User-Agent' => user_agent }
      open(url, options)
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
