module Support
  module OfferParser

    def self.get_location(text, q = 'Location:')
      tokens = text.split(/[\s]/)
      index = tokens.find_index(q)
      return nil unless index

      tokens[index + 1].gsub(',', '')
    end
  end
end
