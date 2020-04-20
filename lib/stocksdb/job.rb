module StocksDB
  class Job
    include Sidekiq::Worker
  end
end
