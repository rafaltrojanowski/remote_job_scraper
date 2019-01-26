require 'spec_helper'

RSpec.describe Sites::JobsRails42 do

  subject { described_class.new() }
  let(:output_file) { Dir.glob('spec/fixtures/data/jobs_rails42/*').first }

  after do
    FileUtils.rm(output_file)
  end

  describe '#collect_jobs' do
    before do
      VCR.use_cassette("jobs_rails42") do
        subject.collect_jobs
      end
    end

    it 'stores data in CSV file' do
      rows = CSV.foreach(output_file).map(&:each)
      expect(rows.size).to eq(250)
    end
  end
end
