config = Rails.application.config.database_configuration[Rails.env]
DB = Sequel.connect(
  adapter: :postgres,
  user: config['username'],
  password: config['password'],
  host: config['host'],
  port: config['port'],
  database: config['database'],
  max_connections: 10,
  logger: Rails.env == 'test' ? nil : ActiveSupport::Logger.new(STDOUT)
)

DB.extension(:pg_json)

# sequel_pg
if Sequel::Postgres.supports_streaming?
  DB.extension(:pg_streaming)
end

