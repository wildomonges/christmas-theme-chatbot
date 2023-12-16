# frozen_string_literal: true

require 'dotenv/load'
require 'aws-sdk-apigatewaymanagementapi'
require 'aws-sdk-bedrockruntime'

require 'models/connection'
require 'services/logger'
require 'services/send_queue_message'

module ChristmasThemeChatbot
  module Functions
    # This class implements the handler function to receive the message
    # from the client side and forward to bedrock api
    class SendMessage
      class << self
        include ChristmasThemeChatbot::Layers::Shared::Models
        include ChristmasThemeChatbot::Layers::Shared::Services

        def handler(event:, context:)
          user_message = JSON.parse(event['body'])['data']
          prompt = build_prompt(user_message).to_json

          request_context = event['requestContext']

          connection_id = request_context['connectionId']
          endpoint = "https://#{request_context['domainName']}/#{request_context['stage']}"

          Logger.instance.info("Handle sendMessage. Event: #{event.to_json}")
          Logger.instance.info("ConnectionId: #{connection_id}")
          Logger.instance.info("Invoking bedrock with prompt: #{prompt}")

          client.invoke_model_with_response_stream(
            body: prompt,
            model_id: MODEL_ID,
            content_type: 'application/json',
            accept: 'application/json',
            event_stream_handler: callback(connection_id, endpoint)
          )

          SendQueueMessage.new(message: { message: user_message, connection_id: connection_id }.to_json, queue_url: ENV['MESSAGES_QUEUE']).call

          { statusCode: 200, body: 'Success' }
        rescue StandardError => e
          Logger.instance.error(e.message)
          
          { statusCode: 500, body: 'We are sorry but something wrong happened! Try again later'}
        end

        private

        ACT_AS_SANTA_CLAUS = 'You are Santa Claus, a friendly old man who talk with people about Christmas'
        MODEL_ID = 'anthropic.claude-v2'

        def client
          @client ||= Aws::BedrockRuntime::Client.new
        end

        def websocket(endpoint)
          @websocket ||= Aws::ApiGatewayManagementApi::Client.new(endpoint: endpoint)
        end

        def callback(connection_id, endpoint)
          Logger.instance.info("Callback invoked by connection #{connection_id} and endpoint #{endpoint}")

          connection = Connection.find(connection_id)

          event_stream_handler = Aws::BedrockRuntime::EventStreams::ResponseStream.new
          event_stream_handler.on_chunk_event do |response_event|
            chunk_response = JSON.parse(response_event.bytes)['completion']
            print chunk_response

            websocket(endpoint).post_to_connection(data: chunk_response, connection_id: connection.connectionId)
          end

          event_stream_handler
        end

        def build_prompt(user_message)
          prompt = "#{ACT_AS_SANTA_CLAUS}\n\n"\
                   "\n\nHuman: #{user_message}\n\nAssistant:"

          {
            prompt: prompt,
            max_tokens_to_sample: 300
          }
        end
      end
    end
  end
end
