# stocksdb

A Ruby app (script?) which collects S&P500 data by:

- Scraping Wikipedia for each S&P500 symbol (so, theoretically, this could be easily expanded to other indices).
- Querying Yahoo's Finance API.

A Sidekiq process makes the requests and persists the data in Postgres.

### Usage

Assuming you're equipped with Docker:

1. Build the images:

```
docker-compose build
```

2. Create a Postgres database:

```
docker-compose up -d postgres
docker-compose run postgres psql -h postgres -U postgres -c "create database stocksdb"
```

3. Create the database tables (TODO: use rake tasks):

```
docker-compose run --rm sidekiq bundle exec bin/console
> StocksDB::DB.create
```

4. Sync the data:

```
docker-compose up -d sidekiq
docker-compose run --rm sidekiq bundle exec bin/console
> StocksDB.sync!
```

The database can be accessed from `localhost` with the following credentials:

- host: `localhost`
- username: `postgres`
- post: `5239`
- database: `stocksdb`

You can monitor the progress of syncs in the `syncs` table and by outputting Sidekiq logs.

### Things to do

- [ ] Add useful Rake tasks
- [ ] Deploy to Heroku
- [ ] Add models
- [ ] Measure sync progress

### License

MIT
