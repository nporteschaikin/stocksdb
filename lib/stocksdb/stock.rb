module StocksDB
  class Stock < ActiveRecord::Base
    class << self
      def from_index_entry(entry)
        attributes = {
          symbol:   entry.symbol,
          security: entry.security,
          url:      entry.url,
        }

        upsert(attributes, unique_by: %i(symbol))
        find_by!(symbol: entry.symbol)
      end
    end

    has_many  :points
    has_one   :quote
  end
end
