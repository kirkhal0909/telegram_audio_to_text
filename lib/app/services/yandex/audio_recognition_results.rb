module TelegramAudioToText
  module Services
    module Yandex
      class AudioRecognitionResults
        attr_reader :file_name, :operation_id, :recognition_client, :bucket_client

        REPEAT_REQUESTS = 30
        TIMEOUT = 10

        def initialize(file_name, operation_id)
          @file_name = file_name
          @operation_id = operation_id
          @recognition_client = APIs::Yandex::Recognition::Client.new
          @bucket_client = APIs::Yandex::BucketClient.new
        end

        def call
          results = sync_read_results
          file_destroy

          results
        end

        private

        def file_destroy
          bucket_client.destroy_file(file_name)
        end

        def sync_read_results
          parsed_response = repeat_request.parsed_response
          chunks = parsed_response.dig('response', 'chunks')
          text = chunks.map { |chunk| chunk.dig('alternatives', 0, 'text') }.compact.join(' ') if chunks
          return { 'result' => text } if text && text != ''

          { 'error_message' => parsed_response.dig('error', 'message') || 'not parsed' }
        end

        def repeat_request
          request_proc = proc { recognition_client.recognition_result_v2(operation_id) }
          response = request_proc.call
          REPEAT_REQUESTS.times do
            break if response.response.content_type == 'application/json' && response.parsed_response['done']

            sleep(TIMEOUT)
            response = request_proc.call
          end
          response
        end
      end
    end
  end
end
