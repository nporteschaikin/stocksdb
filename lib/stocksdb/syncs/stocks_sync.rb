module StocksDB
  module Syncs
    class StocksSync < Sync
      BATCH_SIZE = 25

      def perform
        index = StocksDB::Index.new
        index.each_slice(BATCH_SIZE, &method(:sync_batch))
      end

      private

      def sync_batch(batch)
        stocks = batch.map do |entry|
          stock = StocksDB::Stock.from_index_entry(entry)
          stock.tap do
            PointsSync.create!(args: [stock.id], parent: self)
          end
        end

        QuoteSync.create!(parent: self, args: stocks.map(&:id))
      end
    end
  end
end
