# frozen_string_literal: true

require 'dotenv/load'

require 'models/gift'
require 'services/logger'

module ChristmasThemeChatbot
  module Functions
    # This class implements the handler function to receive the message
    # from the client side and forward to bedrock api
    class GiftRegistration
      class << self
        include ChristmasThemeChatbot::Layers::Shared::Models
        include ChristmasThemeChatbot::Layers::Shared::Services

        def handler(event:, context:)
          Logger.instance.info("Handle event: #{event.to_json}")
          event['Records'].each do |record|
            process_record(record)
          end
        end

        private

        def process_record(record)
          Logger.instance.info("Processing record #{record.to_json}")

          data = JSON.parse(record['body'])
          Logger.instance.info("Body: #{data.to_json}")

          Logger.instance.info("Creating gift record in #{ENV['GIFTS_TABLE']}")

          Gift.create(connectionId: data['connection_id'], username: data['username'], gift: data['gift'])
        end
      end
    end
  end
end
