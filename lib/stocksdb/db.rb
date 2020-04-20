module StocksDB
  class DB
    class << self
      %i(create).each do |method|
        define_method(method) do
          new.send(method)
        end
      end
    end

    def create
      ActiveRecord::Schema.define do
        create_table :stocks, force: :cascade do |t|
          t.string :symbol, index: { unique: true }, null: false
        end

        create_table :syncs, force: :cascade do |t|
          t.string :type, index: true, null: false
          t.jsonb :args, null: false, default: []
          t.string :status, null: false
          t.timestamp :enqueued_at, null: true
          t.timestamp :syncing_at, null: true
          t.timestamp :finished_at, null: true

          t.references :parent, foreign_key: { to_table: :syncs }, null: true

          t.timestamps
        end

        create_table :points, force: :cascade do |t|
          t.references :stock, foreign_key: { on_delete: :cascade }, null: false
          t.timestamp :timestamp, null: false
          t.timestamp :updated_at, null: false

          t.float :high, null: true
          t.float :low, null: true
          t.float :open, null: true
          t.float :close, null: true
          t.float :volume, null: true

          t.index [:stock_id, :timestamp], unique: true
        end

        create_table :quotes, force: :cascade do |t|
          t.references :stock, foreign_key: { on_delete: :cascade }, index: { unique: true }, null: false
          t.timestamp :updated_at, null: false

          t.bigint :price_hint, null: true
          t.float :post_market_change_percent, null: true
          t.bigint :post_market_time, null: true
          t.float :post_market_price, null: true
          t.float :post_market_change, null: true
          t.float :regular_market_change, null: true
          t.float :regular_market_change_percent, null: true
          t.bigint :regular_market_time, null: true
          t.float :regular_market_price, null: true
          t.float :regular_market_day_high, null: true
          t.float :regular_market_day_low, null: true
          t.bigint :regular_market_volume, null: true
          t.float :regular_market_previous_close, null: true
          t.float :bid, null: true
          t.float :ask, null: true
          t.bigint :bid_size, null: true
          t.bigint :ask_size, null: true
          t.float :regular_market_open, null: true
          t.bigint :average_daily_volume3_month, null: true
          t.bigint :average_daily_volume10_day, null: true
          t.float :fifty_two_week_low_change, null: true
          t.float :fifty_two_week_low_change_percent, null: true
          t.float :fifty_two_week_high_change, null: true
          t.float :fifty_two_week_high_change_percent, null: true
          t.float :fifty_two_week_low, null: true
          t.float :fifty_two_week_high, null: true
          t.bigint :dividend_date, null: true
          t.bigint :earnings_timestamp, null: true
          t.bigint :earnings_timestamp_start, null: true
          t.bigint :earnings_timestamp_end, null: true
          t.float :trailing_annual_dividend_rate, null: true
          t.float :trailing_pe, null: true
          t.float :trailing_annual_dividend_yield, null: true
          t.float :eps_trailing_twelve_months, null: true
          t.bigint :first_trade_date_milliseconds, null: true
          t.float :eps_forward, null: true
          t.bigint :shares_outstanding, null: true
          t.float :book_value, null: true
          t.float :fifty_day_average, null: true
          t.float :fifty_day_average_change, null: true
          t.float :fifty_day_average_change_percent, null: true
          t.float :two_hundred_day_average, null: true
          t.float :two_hundred_day_average_change, null: true
          t.float :two_hundred_day_average_change_percent, null: true
          t.bigint :market_cap, null: true
          t.float :forward_pe, null: true
          t.float :price_to_book, null: true
          t.bigint :source_interval, null: true
          t.bigint :exchange_data_delayed_by, null: true
        end
      end
    end
  end
end
