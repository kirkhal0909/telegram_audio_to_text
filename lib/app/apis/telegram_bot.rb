require 'telegram/bot'

module TelegramAudioToText
  module APIs
    class TelegramBot
      attr_reader :client

      MAX_FILE_SIZE = 1024 * 1024 * 10
      INFO_MESSAGE = [
        'Прикрепи новый аудиофайл, чтобы сконвертировать его в текст.',
        "Размер файла должен быть не более #{MAX_FILE_SIZE / 1024 / 1024} Мб"
      ].join("\n").freeze

      def initialize
        @client = TelegramAudioToText::APIs::Telegram::Client.new
      end

      def start
        client.hook { |message| send_message(message.chat.id, prepare_message(message)) }
      end

      private

      def send_message(chat_id, message)
        client.send_message(chat_id, message) if message
      end

      def prepare_message(message)
        case message.text
        when '/start'
          "Привет, #{message.from.first_name}!\n#{INFO_MESSAGE}"
        when nil
          audio_message(message)
        else
          INFO_MESSAGE
        end
      end

      def audio_message(message)
        message_audio = audio(message)
        if message_audio && message_audio.file_size <= MAX_FILE_SIZE
          file = get_file(message_audio.file_id)
          return 'Возникла некоторая ошибка! Попробуйте загрузить файл снова' if file[:error]

          Services::Telegram::AudioToText.new(message.chat.id, file[:binary]).call
        else
          INFO_MESSAGE
        end
      end

      def audio(message)
        message.audio || message.voice
      end

      def get_file(file_id)
        response = client.get_file(file_id)
        { binary: response.body }
      rescue StandardError => e
        # TODO: add some logger
        { error: e.inspect }
      end
    end
  end
end
