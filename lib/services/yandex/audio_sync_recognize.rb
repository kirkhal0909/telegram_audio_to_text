module TelegramAudioToText
  module Services
    module Yandex
      class AudioSyncRecognize
        attr_reader :binary_data, :recognition_client, :bucket_client

        REPEAT_REQUESTS = 3
        TIMEOUT = 3

        def initialize(binary_data)
          @binary_data = binary_data
          @recognition_client = APIs::Yandex::Recognition::Client.new
          @bucket_client = APIs::Yandex::BucketClient.new
        end

        def call
          file_url = file_upload
          response_recognize = start_recognize(file_url)
          result = sync_read_results(response_recognize)
          file_destroy

          result
        rescue StandardError => e
          # TODO: add some logger
          { 'error_message' => e.inspect }
        end

        private

        def file_upload
          bucket_client.upload_file(binary_data, file_name)
        end

        def file_destroy
          bucket_client.destroy_file(file_name)
        end

        def file_name
          @file_name ||= SecureRandom.urlsafe_base64
        end

        def start_recognize(file_url)
          recognition_client.recognize_v2(file_url, extension)
        end

        def sync_read_results(response_recognize)
          operation_id = response_recognize['id']
          return { 'error_message' => parsed_response['message'] } unless operation_id

          request_proc = proc { recognition_client.recognition_result_v2(operation_id) }
          response = request_proc.call
          REPEAT_REQUESTS.times do
            break if response['done']

            sleep(TIMEOUT)
            response = request_proc.call
          end
          response_parsed = response.parsed_response
          chunks = response_parsed.dig('response', 'chunks')
          text = chunks.map { |chunk| chunk.dig('alternatives', 0, 'text') }.compact.join(' ') if chunks
          return { 'result' => text } if text && text != ''

          { 'error_message' => response_parsed.dig('error', 'message') || 'not parsed' }
        end

        def extension
          AudioExtension.new(binary_data).extension
        end
      end
    end
  end
end
