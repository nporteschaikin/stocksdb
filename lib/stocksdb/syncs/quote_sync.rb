module StocksDB
  module Syncs
    class QuoteSync < Sync
      REQUEST_URL = \
        "https://query1.finance.yahoo.com/v7/finance/quote".freeze

      class Adapter
        include Enumerable

        def initialize(body)
          @body = body
        end

        def each
          quote  = body.fetch("quoteResponse")
          result = quote.fetch("result")

          unless result.nil?
            result.each do |row|
              yield(row.fetch("symbol"), transform_attributes(row))
            end
          end
        end

        private

        attr_reader :body

        def transform_attributes(attributes)
          attributes.reduce({}) do |memo, (key, value)|
            memo.tap do
              if StocksDB::Quote.column_names.include?(column = key.underscore)
                memo.merge!(column => value)
              end
            end
          end
        end
      end

      def perform
        stocks = Stock.where(id: args)
        request = StocksDB::Request.new(
          REQUEST_URL,
          query: {
            symbols: stocks.map(&:symbol).join(","),
          },
        )

        response = request.execute
        adapter  = Adapter.new(JSON.parse(response.body))

        adapter.each do |symbol, attributes|
          stock = Stock.find_by!(symbol: symbol)

          Quote.upsert(
            attributes.merge(
              stock_id: stock.id,
              updated_at: Time.now,
            ),
            unique_by: %i(stock_id),
          )
        end
      end
    end
  end
end
