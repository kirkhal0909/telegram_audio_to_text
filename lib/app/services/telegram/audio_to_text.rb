module TelegramAudioToText
  module Services
    module Telegram
      class AudioToText
        attr_reader :file_name, :chat_id, :binary_data

        def initialize(chat_id, binary_data)
          @file_name = SecureRandom.urlsafe_base64
          @chat_id = chat_id
          @binary_data = binary_data
        end

        def call
          response = TelegramAudioToText::Services::Yandex::AudioRecognizeStart.new(binary_data, file_name).call
          operation_id = response['id']
          return { 'error_message' => parsed_response['message'] } unless operation_id

          send_message_on_end(operation_id)

          'Ожидайте! Ваше сообщение распознаётся. Позже пришлём результаты'
        end

        private

        def send_message_on_end(operation_id)
          TelegramAudioToText::Workers::Yandex::SendRecognitionResult.perform_async(chat_id, file_name, operation_id)
        end
      end
    end
  end
end
