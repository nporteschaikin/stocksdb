module StocksDB
  class Stock < ActiveRecord::Base
    class << self
      def from_index_entry(entry)
        attributes = {
          symbol: entry.symbol,
        }

        upsert(attributes, unique_by: %i(symbol))
        find_by!(symbol: entry.symbol)
      end
    end

    has_many  :points
    has_one   :quote
  end
end
