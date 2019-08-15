require 'spec_helper'

RSpec.describe Sites::ElixirCompanies do

  subject { described_class.new }
  let(:output_file) { Dir.glob('spec/fixtures/data/elixir_companies/*').first }

  describe '#collect_companies' do

    after do
      FileUtils.rm(output_file)
    end

    before do
      VCR.use_cassette("elixir_companies") do
        subject.collect_companies
      end
    end

    it 'writes data to CSV file' do
      rows = CSV.foreach(output_file).map(&:each)
      expect(rows.size).to eq(404)
    end

    it 'returns jobs count' do
      expect(subject.companies_count).to eq(404)
    end

    it 'returns rows count' do
      expect(subject.rows_count).to eq(404)
    end
  end
end
