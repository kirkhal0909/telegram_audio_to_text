module TelegramAudioToText
  module APIs
    module Yandex
      class BucketClient
        def upload_file(binary, file_name)
          YANDEX_BUCKET.put_object(
            bucket: bucket_name,
            key: file_name,
            body: binary
          )

          "https://storage.yandexcloud.net/#{ENV.fetch('YANDEX_BUCKET_NAME')}/#{file_name}"
        end

        def destroy_file(file_name)
          YANDEX_BUCKET.delete_object(
            bucket: bucket_name,
            key: file_name
          )
        end

        private

        def bucket_name
          ENV.fetch('YANDEX_BUCKET_NAME')
        end
      end
    end
  end
end
