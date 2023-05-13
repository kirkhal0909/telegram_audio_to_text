module TelegramAudioToText
  module APIs
    class YandexRecognition
      FOLDER_ID = ENV.fetch('YANDEX_FOLDER_ID')
      API_KEY = ENV.fetch('YANDEX_API_KEY')
      RECOGNIZE_URL = "https://stt.api.cloud.yandex.net/speech/v1/stt:recognize?folderId=#{FOLDER_ID}&lang=ru-RU&format=oggopus".freeze

      def recognize(binary_file)
        HTTParty.post(RECOGNIZE_URL, body: binary_file, headers: headers).parsed_response
      rescue StandardError => e
        # TODO: add some logger
        { 'error_message' => e.inspect }
      end

      private

      def headers
        {
          'Authorization' => "Api-Key #{API_KEY}",
          'Transfer-Encoding' => 'chunked'
        }
      end
    end
  end
end
