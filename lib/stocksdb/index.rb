module StocksDB
  class Index
    include Enumerable

    class Entry
      attr_reader :symbol

      def initialize(symbol, url:, security:)
        @symbol   = symbol
        @url      = url
        @security = security
      end

      def valid?
        symbol.size > 0
      end
    end

    WIKIPEDIA_URL = "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies".freeze

    def each
      request   = Request.new(WIKIPEDIA_URL)
      response  = request.execute
      html      = Nokogiri::HTML(response.body)
      rows      = html.xpath("//table[1]/tbody/tr")

      rows.each do |row|
        entry = Entry.new(
          row.xpath("./td[1]").text.strip,
          url:      row.xpath("./td[1]/a/@href").text.strip,
          security: row.xpath("./td[2]").text.strip,
        )

        if entry.valid?
          yield(entry)
        end
      end
    end
  end
end
