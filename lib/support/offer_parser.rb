module Support
  module OfferParser

    LOCATION_DICT = ['location', 'based']
    KEYWORDS      = [
      'ruby',
      'elixir',
      'react',
      'remote',
      'graphql'
    ]

    def self.get_location(content, dict = LOCATION_DICT)
      indexes = Array.new
      tokens = get_tokens(content)
      indexes = dict.map { |q| [tokens.find_index(q), q] }
      locations = Array.new

      indexes.each do |index|
        next if index[0].nil?

        locations << tokens[index[0] + 1] if index[1] == 'location'
        locations << tokens[index[0] - 1..index[0] + 2] if index[1] == 'based'
      end

      locations.join(' ').capitalize
    end

    def self.get_keywords(content, keywords)
      keywords = keywords || KEYWORDS
      indexes = Array.new
      tokens = get_tokens(content)
      indexes = keywords.map { |q| [tokens.find_index(q), q] }
      keywords = Array.new

      indexes.each do |index|
        next if index[0].nil?
        keywords << tokens[index[0]].gsub(',', '')
      end

      keywords.map(&:capitalize).join(', ')
    end

    def self.get_tokens(content)
      content
        .gsub(/\W+/, ' ') # remove non letters
        .downcase
        .split(/[\s-]/)
    end
  end
end
