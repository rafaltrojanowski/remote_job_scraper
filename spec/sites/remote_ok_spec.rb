require 'spec_helper'

RSpec.describe Sites::RemoteOk do

  subject { described_class.new() }
  let(:output_file) { Dir.glob('spec/fixtures/data/remote_ok/*').first }

  after do
    FileUtils.rm(output_file)
  end

  describe '#collect_jobs' do
    before do
      VCR.use_cassette("remote_ok") do
        subject.collect_jobs
      end
    end

    it 'writes data to CSV file' do
      rows = CSV.foreach(output_file).map(&:each)
      expect(rows.size).to eq(906)
    end

    it 'stores data in a row' do
      rows = CSV.foreach(output_file).map(&:each)
      expect(rows.first.to_a).to eq(
        ["https://remoteok.io/remote-jobs/70723-remote-software-engineer-spencers",
         "",
         "Remote",
         "Spencer's"
        ]
      )
    end
  end
end
