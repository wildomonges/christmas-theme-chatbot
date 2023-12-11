# frozen_string_literal: true

require 'models/connection'
require 'services/logger'

module ChristmasThemeChatbot
  module Functions
    # This class implements the handler function to disconnect websocket for an existing connection
    class OnDisconnect
      class << self
        include ChristmasThemeChatbot::Layers::Shared::Models
        include ChristmasThemeChatbot::Layers::Shared::Services

        def handler(event:, context:)
          Logger.instance.info("Handle onDisconnect. Event: #{event.to_json}")

          connection_id = event.dig('requestContext', 'connectionId')
          Logger.instance.info("ConnectionId: #{connection_id}")

          Connection.find(connection_id).delete
          Logger.instance.info("Connection #{connection_id} deleted")

          { statusCode: 204, body: '' }
        end
      end
    end
  end
end
