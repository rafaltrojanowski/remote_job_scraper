require 'spreadsheet'

module Support
  module SpreadsheetCreator

    def self.generate(base_path: 'data/summary/', filename: 'remote_job_summary.xls')
      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet::Workbook.new

      dirnames.each_with_index do |dirname, index|
        file = Dir.glob(dirname).first
        sheet = book.create_worksheet name: dirname.split("/")[-2]
        column_width.each { |idx, width| sheet.column(idx).width = width }

        next if file.nil?

        CSV.foreach(file).with_index(0) do |row, index|
          sheet.row(index).push(*(Spreadsheet::Link.new row[0]), *row[1..-1])
        end
      end

      FileUtils.mkdir_p absolute_path(base_path)
      book.write filepath(base_path, filename)
    end

    def self.column_width
      {
        0 => 90,
        1 => 20,
        2 => 20,
        3 => 20,
        4 => 20
      }
    end

    def self.filepath(path, filename)
      absolute_path(path).concat(
        Time.now.strftime("%Y%m%d%H%M%S")
          .concat('_')
          .concat(filename)
      )
    end

    def self.absolute_path(path)
      return path unless ENV['RAILS_ENV'] == 'test'
      "#{RemoteJobScraper.root}/spec/fixtures/#{path}"
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
          "#{Dir.pwd}/data/remote_ok/*",
          "#{Dir.pwd}/data/we_work_remotely/*",
          "#{Dir.pwd}/data/jobs_rails42/*"
        ]
      end
    end
  end
end
