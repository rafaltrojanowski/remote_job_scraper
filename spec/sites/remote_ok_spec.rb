require 'spec_helper'

RSpec.describe Sites::RemoteOk do

  let(:output_file) { Dir.glob('spec/fixtures/data/remote_ok/*').first }

  describe '#collect_jobs' do

    after do
      FileUtils.rm(output_file)
    end

    context 'with no limit', speed: 'slow' do
      subject { described_class.new }

      before do
        VCR.use_cassette("remote_ok") do
          subject.collect_jobs
        end
      end

      it 'writes data to CSV file' do
        rows = CSV.foreach(output_file).map(&:each)
        expect(rows.size).to eq(906)
      end
    end

    context 'with limit' do
      subject { described_class.new }

      before do
        VCR.use_cassette("remote_ok") do
          subject.collect_jobs(limit: 1)
        end
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

      it 'returns jobs count' do
        expect(subject.jobs_count).to eq(906)
      end

      it 'returns rows count' do
        expect(subject.rows_count).to eq(1)
      end

      it 'writes data to CSV file' do
        rows = CSV.foreach(output_file).map(&:each)
        expect(rows.size).to eq(1)
      end
    end
  end
end
