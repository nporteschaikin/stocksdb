module StocksDB
  class Quote < ActiveRecord::Base
    belongs_to :stock
  end
end
