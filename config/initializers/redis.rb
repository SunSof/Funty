require 'redis'

# Define the redis server url
redis_url = 'redis://redis:6379'

# Create a new redis client using the url
$redis = Redis.new
