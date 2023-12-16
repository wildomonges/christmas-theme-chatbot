# frozen_string_literal: true

require 'services/logger'

module ChristmasThemeChatbot
  module Functions
    # This class implements the handler function to connect to the websocket
    class Authorizer
      class << self
        include ChristmasThemeChatbot::Layers::Shared::Services

        def handler(event:, context:)
          Logger.instance.info("Handle event. Event: #{event.to_json}")
        end
      end
    end
  end
end
