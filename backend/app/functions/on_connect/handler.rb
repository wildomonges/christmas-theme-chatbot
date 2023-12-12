# frozen_string_literal: true

require 'models/connection'
require 'services/logger'

module ChristmasThemeChatbot
  module Functions
    # This class implements the handler function to connect to the websocket
    class OnConnect
      class << self
        include ChristmasThemeChatbot::Layers::Shared::Models
        include ChristmasThemeChatbot::Layers::Shared::Services

        def handler(event:, context:)
          Logger.instance.info("Handle event onConnect. Event: #{event.to_json}")

          connection_id = event.dig('requestContext', 'connectionId')
          Logger.instance.info("ConnectionId: #{connection_id}")

          Connection.create(connectionId: connection_id)
          Logger.instance.info('New connection created')

          { statusCode: 200, body: 'Successfully created a new connection' }
        end
      end
    end
  end
end
