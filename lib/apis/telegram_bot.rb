require 'telegram/bot'

module TelegramAudioToText
  module APIs
    class TelegramBot
      API_KEY = ENV.fetch('TELEGRAM_API')
      MAX_FILE_SIZE = 1024 * 1024 * 10 # 10 megabytes
      INFO_MESSAGE = [
        'Прикрепи новый аудиофайл, чтобы сконвертировать его в текст.',
        "Размер файла должен быть не более #{MAX_FILE_SIZE / 1024 / 1024} Мб"
      ].join("\n").freeze
      GET_FILE_LINK = "https://api.telegram.org/file/bot#{API_KEY}/".freeze

      def start
        Telegram::Bot::Client.run(API_KEY) do |bot|
          bot.listen do |message|
            send_message(bot, message)
          end
        end
      end

      private

      def send_message(bot, message)
        prepare_message = case message.text
                          when '/start'
                            "Привет, #{message.from.first_name}!\n#{INFO_MESSAGE}"
                          when nil
                            audio_message(bot, message)
                          else
                            INFO_MESSAGE
                          end
        bot.api.send_message(chat_id: message.chat.id, text: prepare_message)
      end

      def audio_message(bot, message)
        if message.audio && message.audio.file_size <= MAX_FILE_SIZE
          file = get_file(bot, message.audio.file_id)
          return 'Возникла некоторая ошибка! Попробуйте загрузить файл снова' if file[:error]

          # TODO: add recognition text
          'some recognition text'
        else
          INFO_MESSAGE
        end
      end

      def get_file(bot, file_id)
        file_path = bot.api.get_file(file_id: file_id).dig('result', 'file_path')
        response = HTTParty.get("#{GET_FILE_LINK}#{file_path}")
        { binary: response.body }
      rescue StandardError => e
        # TODO: add some logger
        { error: e.inspect }
      end
    end
  end
end
