module Sites
  class GithubRemoteJobs < Base

    HOST = 'http://github.com/'.freeze
    PATH = 'remoteintech/remote-jobs'
    JOB_ITEM_SELECTOR = '.entry-content table tbody tr'.freeze
    STORE_DIR = 'data/github_remote_jobs'.freeze

    def initialize()
      @url = "#{self.class::HOST}#{self.class::PATH}"
      @current_time = Time.now
      @timestamp = @current_time.strftime("%Y%m%d%H%M%S")
      @doc = Nokogiri::HTML(open_page(@url))
      @rows_count = 0
    end

    def collect_companies
      puts "[Info] Getting the data from #{url}"
      FileUtils.mkdir_p STORE_DIR

      CSV.open(filepath, 'w') do |csv|
        doc.css(JOB_ITEM_SELECTOR).each do |tr|
          name = tr.search('td')[0].text
          website = tr.search('td')[1].text
          region = tr.search('td')[2].text
          csv << [name, website, region]
          @rows_count += 1
        end
      end
      puts "[Done] Collected #{@rows_count} job offers from #{url}. Data stored in: #{filepath}."
    end

    def companies_count
      @rows_count
    end

  end
end
