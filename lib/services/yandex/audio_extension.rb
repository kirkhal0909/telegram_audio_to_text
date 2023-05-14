module TelegramAudioToText
  module Services
    module Yandex
      class AudioExtension
        OGG_FORMAT = 'Ogg'.freeze
        MP3_FORMAT = 'ID3'.freeze

        def initialize(binary_data)
          @binary_data = binary_data
        end

        def extension
          case @binary_data[..2]
          when OGG_FORMAT
            'OGG_OPUS'
          when MP3_FORMAT
            'MP3'
          else
            'LINEAR16_PCM'
          end
        end
      end
    end
  end
end
