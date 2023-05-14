module TelegramAudioToText
  module Services
    module Yandex
      class AudioRecognizeStart
        attr_reader :file_name, :binary_data, :recognition_client, :bucket_client

        def initialize(binary_data, file_name)
          @file_name = file_name
          @binary_data = binary_data
          @recognition_client = APIs::Yandex::Recognition::Client.new
          @bucket_client = APIs::Yandex::BucketClient.new
        end

        def call
          file_url = file_upload
          start_recognize(file_url)
        rescue StandardError => e
          # TODO: add some logger
          { 'error_message' => e.inspect }
        end

        private

        def file_upload
          bucket_client.upload_file(binary_data, file_name)
        end

        def start_recognize(file_url)
          recognition_client.recognize_v2(file_url, extension)
        end

        def extension
          AudioExtension.new(binary_data).extension
        end
      end
    end
  end
end
