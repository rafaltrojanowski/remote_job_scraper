require 'spec_helper'

RSpec.describe Support::SpreadsheetCreator do

  subject { Support::SpreadsheetCreator }

  let(:output_file_1) { Dir.glob('spec/fixtures/data/we_work_remotely/*').first }
  let(:output_file_2) { Dir.glob('spec/fixtures/data/remote_ok/*').first }

  after do
    FileUtils.rm_rf("#{RemoteJobScraper.root}/spec/fixtures/data/summary")
  end

  describe ".generate" do
    it 'generates xls file' do
      subject.generate
      expect(Dir.glob('spec/fixtures/data/summary/*').first).to_not eq(nil)
    end
  end
end

