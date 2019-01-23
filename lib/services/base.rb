module Services
  class Base

    attr_reader :job_type, :doc, :url

    def initialize(job_type: :programming)
      @job_type = job_type
      @url = build_url
      @doc = Nokogiri::HTML(open(@url))
      @current_time = Time.new
      @timestamp = @current_time.strftime("%Y%m%d%H%M%S")
      @count = get_count
    end

    private

    def build_url
      case job_type
        when :programming
          then "#{self.class::HOST}#{self.class::PROGRAMMING}"
        when :devops
          then "#{self.class::HOST}#{self.class::DEVOPS}"
        else
          raise "Error"
        end
    end

    def file_name
      return "spec/fixtures/data/#{underscore(self.class.name.split('::').last)}.csv" if ENV["RAILS_ENV"] == 'test'

      "#{self.class::STORE_DIR}/#{@timestamp}.csv"
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
