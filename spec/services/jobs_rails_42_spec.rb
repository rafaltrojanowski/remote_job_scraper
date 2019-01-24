require 'spec_helper'

RSpec.describe Services::JobsRails42 do

  subject { described_class.new(args) }
  let(:args) {{ }}

  after do
    # FileUtils.rm("spec/fixtures/data/jobs_rails42.csv")
  end

  describe '#collect_jobs' do
    before do
      VCR.use_cassette("jobs_rails42") do
        subject.collect_jobs
      end
    end

    it 'stores data in CSV file' do
      rows = CSV.foreach("spec/fixtures/data/jobs_rails42.csv").map(&:each)
      expect(rows.size).to eq(25)
    end
  end
end
