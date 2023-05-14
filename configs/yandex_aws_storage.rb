Aws.config.update(
  region: ENV.fetch('YANDEX_BUCKET_REGION'),
  credentials: Aws::Credentials.new(
    ENV.fetch('YANDEX_KEY_ID'),
    ENV.fetch('YANDEX_SECRET')
  ),
  endpoint: ENV.fetch('YANDEX_BUCKET_ENDPOINT')
)

YANDEX_BUCKET = Aws::S3::Client.new
