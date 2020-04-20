module StocksDB
  class Sync < ActiveRecord::Base
    NEW = "new".freeze
    ENQUEUED = "enqueued".freeze
    SYNCING = "syncing".freeze
    FINISHED = "finished".freeze
    ERRORED = "errored".freeze

    belongs_to :parent, class_name: "Sync", foreign_key: :parent_id
    has_many :children, class_name: "Sync", foreign_key: :parent_id
    attribute :status, :string, default: NEW

    after_create { enqueue! }

    def run!
      syncing!
      perform
      finished!
    rescue
      errored!
      raise
    end

    def enqueue!
      Jobs::SyncJob.perform_async(id)
      enqueued!
    end

    private

    def enqueued!
      update!(
        status: ENQUEUED,
        enqueued_at: Time.now,
        syncing_at: nil,
        finished_at: nil,
      )
    end

    def syncing!
      update!(
        status: SYNCING,
        syncing_at: Time.now,
        finished_at: nil,
      )
    end

    def finished!
      update!(status: FINISHED, finished_at: Time.now)
    end

    def errored!
      update!(status: ERRORED, finished_at: Time.now)
    end
  end
end
