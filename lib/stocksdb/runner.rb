module StocksDB
  class Syncer
    def run
      index = Index.new
      index.each do |entry|
        entry = Stock.from_index_entry(entry)
        entry.sync!

        sleep(1)
      end
    end
  end
end
