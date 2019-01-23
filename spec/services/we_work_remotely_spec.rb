require 'spec_helper'

RSpec.describe Services::WeWorkRemotely do

  subject { described_class.new(args) }
  let(:args) {{ }}

  after do
    FileUtils.rm("spec/fixtures/data/we_work_remotely.csv")
  end

  describe '#collect_jobs' do
    before do
      VCR.use_cassette("we_work_remotely") do
        subject.collect_jobs
      end
    end

    it 'stores data in CSV file' do
      rows = CSV.foreach("spec/fixtures/data/we_work_remotely.csv").map(&:each)
      expect(rows.size).to eq(186)
    end
  end
end
