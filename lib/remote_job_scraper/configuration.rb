module RemoteJobScraper
  class Configuration
    attr_accessor :delay_range

    def initialize
      @delay_range = 0..2.0
    end
  end
end

