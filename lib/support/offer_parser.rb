module Support
  module OfferParser

    LOCATION_DICT = ['location', 'based']

    def self.get_location(text, dict = LOCATION_DICT)
      indexes = Array.new
      tokens = text
        .gsub('.', '')
        .gsub(',', '')
        .gsub(':', '')
        .downcase
        .split(/[\s-]/)

      indexes = dict.map { |q| [tokens.find_index(q), q] }

      words = Array.new

      indexes.each do |index|
        next if index[0].nil?

        words << tokens[index[0] + 1].gsub(',', '') if index[1] == 'location'
        words << tokens[index[0] - 1].gsub(',', '') if index[1] == 'based'
      end

      words.join(', ').capitalize
    end
  end
end
