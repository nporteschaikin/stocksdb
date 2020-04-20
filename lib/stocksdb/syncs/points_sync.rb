module StocksDB
  module Syncs
    class PointsSync < Sync
      REQUEST_URL_FORMAT = \
        "https://query1.finance.yahoo.com/v7/finance/chart/%s".freeze
      QUERY = {
        range: %q(1wk),
      }.freeze

      class Adapter
        include Enumerable

        def initialize(body)
          @body = body
        end

        def each
          chart  = body.fetch("chart")
          result = (chart.fetch("result") || []).first

          unless result.nil?
            timestamps  = result.fetch("timestamp", [])
            raw_quote   = result.fetch("indicators").fetch("quote").first

            timestamps.each_with_index do |timestamp, index|
              yield(
                Time.at(timestamp),
                high:   raw_quote.fetch("high")[index],
                low:    raw_quote.fetch("low")[index],
                open:   raw_quote.fetch("open")[index],
                close:  raw_quote.fetch("close")[index],
                volume: raw_quote.fetch("volume")[index]
              )
            end
          end
        end

        private

        attr_reader :body
      end

      def perform
        stock   = StocksDB::Stock.find(args.first)
        request = StocksDB::Request.new(
          REQUEST_URL_FORMAT % stock.symbol,
          query: QUERY,
        )

        response  = request.execute
        points    = Adapter.new(JSON.parse(response.body))

        points.each do |timestamp, point|
          Point.upsert(
            point.merge(
              stock_id: stock.id,
              timestamp: timestamp,
              updated_at: Time.now,
            ),
            unique_by: %i(stock_id timestamp),
          )
        end
      end
    end
  end
end
