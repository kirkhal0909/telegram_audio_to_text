require_relative 'lib/telegram_audio_to_text'

print('Start Telegram bot')

TelegramAudioToText::APIs::TelegramBot.new.start

print('Stop Telegram bot')
