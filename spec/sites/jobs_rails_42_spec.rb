require 'spec_helper'

RSpec.describe Sites::JobsRails42 do

  subject { described_class.new }
  let(:output_file) { Dir.glob('spec/fixtures/data/jobs_rails42/*').first }

  after do
    FileUtils.rm(output_file)
  end

  describe '#collect_jobs' do
    context 'without limit', speed: 'slow' do
      before do
        VCR.use_cassette("jobs_rails42") do
          subject.collect_jobs
        end
      end

      it 'writes data to CSV file' do
        rows = CSV.foreach(output_file).map(&:each)
        expect(rows.size).to eq(100)
      end
    end

    context 'with limit' do
      before do
        VCR.use_cassette("jobs_rails42") do
          subject.collect_jobs(limit: 1)
        end
      end

      it 'stores data in a row' do
        rows = CSV.foreach(output_file).map(&:each)
        expect(rows.first.to_a).to eq(
          ["https://www.42jobs.io/rails/jobs/5006-ruby-on-rails-developer",
           "11 based in australia",
           "Ruby, Remote",
           "SmartrMail"
          ]
        )
      end

      it 'returns jobs count' do
        expect(subject.jobs_count).to eq(100)
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
