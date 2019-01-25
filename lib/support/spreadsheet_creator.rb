require 'spreadsheet'

module Support
  module SpreadsheetCreator

    def self.generate(path: 'data/summary/', filename: 'remote_job_summary_.xls')
      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet::Workbook.new

      dirnames.each_with_index do |dirname, index|
        file = Dir.glob(dirname).first
        sheet = book.create_worksheet name: dirname.split("/")[-2]

        CSV.foreach(file).with_index(0) do |row, index|
          sheet.row(index).push(*(Spreadsheet::Link.new row[0]), *row[1..-1])
        end
      end

      book.write path.concat(
        Time.now.strftime("%Y%m%d%H%M%S").concat('_remote_jobs_summary.xls')
      )
    end

    def self.dirnames
      if ENV['RAILS_ENV'] == 'test'
        [
          "#{RemoteJobScraper.root}/spec/fixtures/data/remote_ok/*",
          "#{RemoteJobScraper.root}/spec/fixtures/data/we_work_remotely/*",
          "#{RemoteJobScraper.root}/spec/fixtures/data/jobs_rails42/*"
        ]
      else
        [
          "#{RemoteJobScraper.root}/data/remote_ok/*",
          "#{RemoteJobScraper.root}/data/we_work_remotely/*",
          "#{RemoteJobScraper.root}/data/jobs_rails42/*"
        ]
      end
    end
  end
end
