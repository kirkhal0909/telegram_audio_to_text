module TelegramAudioToText
  module APIs
    module Yandex
      module Recognition
        class Client
          API_KEY = ENV.fetch('YANDEX_API_KEY')
          RECOGNIZE_V2_URL = 'https://transcribe.api.cloud.yandex.net/speech/stt/v2/longRunningRecognize'.freeze
          RECOGNIZE_STATUS_V2_URL = 'https://operation.api.cloud.yandex.net/operations/'.freeze

          def recognize_v2(file_url, extension)
            HTTParty.post(
              RECOGNIZE_V2_URL,
              body: recognize_v2_body(file_url, extension),
              headers: headers
            )
          end

          def recognition_result_v2(operation_id)
            HTTParty.get("#{RECOGNIZE_STATUS_V2_URL}#{operation_id}", headers: headers)
          end

          private

          def recognize_v2_body(file_url, extension)
            {
              config: {
                specification: {
                  languageCode: 'ru-RU',
                  audioEncoding: extension
                }
              },
              audio: { uri: file_url }
            }.to_json
          end

          def headers
            {
              'Authorization' => "Api-Key #{API_KEY}",
              'Content-Type' => 'application/json'
            }
          end
        end
      end
    end
  end
end
