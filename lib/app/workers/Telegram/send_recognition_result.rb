module TelegramAudioToText
  module Workers
    module Yandex
      class SendRecognitionResult
        include Sidekiq::Worker
        sidekiq_options queue: 'telegram', retry: false

        def perform(chat_id, file_name, operation_id)
          results = ::TelegramAudioToText::Services::Yandex::AudioRecognitionResults.new(file_name, operation_id).call
          message = results['result'] || results['error_message']
        rescue StandardError => e
          # TODO: add some logger
          message = e.inspect
        ensure
          ::TelegramAudioToText::APIs::Telegram::Client.new.send_message(chat_id, message)
        end
      end
    end
  end
end
