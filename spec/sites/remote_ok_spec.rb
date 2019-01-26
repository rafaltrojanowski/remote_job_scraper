require 'spec_helper'

RSpec.describe Sites::RemoteOk do

  subject { described_class.new() }
  let(:output_file) { Dir.glob('spec/fixtures/data/remote_ok/*').first }

  after do
    # FileUtils.rm(output_file)
  end

  describe '#collect_jobs' do
    before do
      VCR.use_cassette("remote_ok") do
        subject.collect_jobs
      end
    end

    it 'stores data in CSV file' do
      rows = CSV.foreach(output_file).map(&:each)
      expect(rows.size).to eq(906)
    end
  end
end
