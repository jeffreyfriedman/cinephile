CarrierWave.configure do |config|
  unless Rails.env.test?
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: "us-west-2"
    }
    config.fog_directory = "mcwcinephile"
  end
end
