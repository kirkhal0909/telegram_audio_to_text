require 'telegram/bot'

module TelegramAudioToText
  module APIs
    class TelegramBot
      API_KEY = ENV.fetch('TELEGRAM_API')

      def start
        Telegram::Bot::Client.run(API_KEY) do |bot|
          bot.listen do |message|
            case message.text
            when '/start'
              bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
            when '/stop'
              bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
            end
          end
        end
      end
    end
  end
end
