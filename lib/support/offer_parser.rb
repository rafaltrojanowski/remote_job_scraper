module Support
  module OfferParser

    LOCATION_DICT = ['location', 'based']
    KEYWORDS      = ['ruby', 'elixir']

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

    def self.get_keywords(text, keywords = KEYWORDS)
      indexes = Array.new
      tokens = text
        .gsub('.', '')
        .gsub(',', '')
        .gsub(':', '')
        .downcase
        .split(/[\s-]/)

      indexes = keywords.map { |q| [tokens.find_index(q), q] }

      words = Array.new

      indexes.each do |index|
        next if index[0].nil?
        words << tokens[index[0]].gsub(',', '')
      end

      words.map(&:capitalize).join(', ')
    end
  end
end
