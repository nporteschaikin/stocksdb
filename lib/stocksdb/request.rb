require "net/http"

module StocksDB
  class Request
    attr_reader :url, :headers, :query

    def initialize(url, headers: {}, query: {})
      @url      = url
      @headers  = headers.dup
      @query    = query.dup
    end

    def execute
      Faraday.get(uri, query, headers)
    end

    private

    def uri
      @uri ||= URI(url).tap do |u|
        (u.query = query.to_query) if query.keys.any?
      end
    end
  end
end
