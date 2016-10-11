@client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV["TWITTER_API_Key"]
  config.consumer_secret = ENV["TWITTER_API_Secret_Key"]
  config.access_token = ENV["TWITTER_Access_Token"]
  config.access_token_secret = ENV["TWITTER_Access_Secret_Token"]
end
