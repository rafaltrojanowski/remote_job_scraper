require 'spec_helper'

RSpec.describe Services::RemoteOk do

  subject { described_class.new(args) }
  let(:args) {{ }}

  after do
    # FileUtils.rm("spec/fixtures/data/remote_ok.csv")
  end

  describe '#collect_jobs' do
    before do
      VCR.use_cassette("remote_ok") do
        subject.collect_jobs
      end
    end

    it 'stores data in CSV file' do
      rows = CSV.foreach("spec/fixtures/data/remote_ok.csv").map(&:each)
      expect(rows.size).to eq(906)
    end
  end
end
