require 'telegram/bot'

module TelegramAudioToText
  module APIs
    module Telegram
      class Client
        API_KEY = ENV.fetch('TELEGRAM_API')
        GET_FILE_LINK = "https://api.telegram.org/file/bot#{API_KEY}/".freeze

        def hook(&)
          client { |api| api.listen(&) }
        end

        def send_message(chat_id, message)
          client { |api| api.api.send_message(chat_id: chat_id, text: message) }
        end

        def get_file(file_id)
          file_path = client { |api| api.api.get_file(file_id: file_id).dig('result', 'file_path') }
          HTTParty.get("#{GET_FILE_LINK}#{file_path}")
        end

        private

        def client(&)
          ::Telegram::Bot::Client.run(API_KEY, &)
        end
      end
    end
  end
end
