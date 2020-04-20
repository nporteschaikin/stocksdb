require "active_record"
require "faraday"
require "nokogiri"
require "pg"
require "sidekiq"
require "uri"

require "stocksdb/db"
require "stocksdb/index"
require "stocksdb/job"
require "stocksdb/jobs/sync_job"
require "stocksdb/point"
require "stocksdb/quote"
require "stocksdb/request"
require "stocksdb/stock"
require "stocksdb/sync"
require "stocksdb/syncs/points_sync"
require "stocksdb/syncs/quote_sync"
require "stocksdb/syncs/stocks_sync"

ActiveRecord::Base.establish_connection(ENV.fetch("DATABASE_URL"))

module StocksDB
  class << self
    def sync!
      Syncs::StocksSync.create!
    end

    def create_database
      DB.create
    end
  end
end
