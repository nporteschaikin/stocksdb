module StocksDB
  class Point < ActiveRecord::Base
    belongs_to :stock
  end
end
