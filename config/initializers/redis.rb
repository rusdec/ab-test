config = YAML.load(File.read("config/redis.yml"), aliases: true)[Rails.env]

RedisConnection = Redis.new(
  host: config['host'],
  port: config['port']
)
