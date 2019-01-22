module Services
  class Base

    attr_reader :job_type, :doc, :url

    def initialize(job_type: :programming)
      @job_type = job_type
      @url = build_url
      @doc = Nokogiri::HTML(open(@url))
      @current_time = Time.new
      @timestamp = @current_time.to_i
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
      "#{self.class::STORE_DIR}/#{@timestamp}.csv"
    end
  end
end
