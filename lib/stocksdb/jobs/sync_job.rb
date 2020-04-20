module StocksDB
  module Jobs
    class SyncJob < StocksDB::Job
      def perform(id)
        sync = StocksDB::Sync.find_by(id: id)
        sync.run! if sync.present?
      end
    end
  end
end
