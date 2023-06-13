config = Rails.application.config.database_configuration[Rails.env]
DB = Sequel.connect(
  adapter: :postgres,
  user: config['username'],
  password: config['password'],
  host: config['host'],
  port: config['port'],
  database: config['database'],
  max_connections: config['pool'],
  logger: Rails.logger
)

DB.extension(:pg_json)
