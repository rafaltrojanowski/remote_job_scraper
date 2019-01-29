require 'spec_helper'

RSpec.describe Sites::WeWorkRemotely do

  subject { described_class.new }
  let(:output_file) { Dir.glob('spec/fixtures/data/we_work_remotely/*').first }

  after do
    FileUtils.rm(output_file)
  end

  describe '#collect_jobs' do
    before do
      VCR.use_cassette("we_work_remotely") do
        subject.collect_jobs
      end
    end

    it 'writes data to CSV file' do
      rows = CSV.foreach(output_file).map(&:each)
      expect(rows.size).to eq(186)
    end

    it 'stores data in a row' do
      rows = CSV.foreach(output_file).map(&:each)
      expect(rows.first.to_a).to eq(
        ["https://weworkremotely.com/remote-jobs/hotjar-senior-software-engineer-backend-emea",
         "Headquarters: Malta",
         "Must be located: EMEA",
         "Remote",
         "Hotjar"
        ]
      )
    end
  end
end
