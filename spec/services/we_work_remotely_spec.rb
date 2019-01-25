require 'spec_helper'

RSpec.describe Services::WeWorkRemotely do

  subject { described_class.new }
  let(:output_file) { Dir.glob('spec/fixtures/data/we_work_remotely/*').first }

  after do
    # FileUtils.rm(output_file)
  end

  describe '#collect_jobs' do
    before do
      VCR.use_cassette("we_work_remotely") do
        subject.collect_jobs
      end
    end

    it 'stores data in CSV file' do
      rows = CSV.foreach(output_file).map(&:each)
      expect(rows.size).to eq(186)
    end
  end
end
