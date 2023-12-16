# frozen_string_literal: true

require 'dotenv/load'
require 'aws-sdk-bedrockruntime'

require 'services/logger'
require 'services/send_queue_message'

module ChristmasThemeChatbot
  module Functions
    # This class implements the handler function to receive the message
    # from the client side and forward to bedrock api
    class MessageAnalyzer
      class << self
        include ChristmasThemeChatbot::Layers::Shared::Services

        def handler(event:, context:)
          Logger.instance.info("Handle event: #{event.to_json}")

          event['Records'].each do |record|
            process_record(record)
          end
        end

        private

        ACT_AS_GIFT_DISCOVER = 'Given the next message sent by a child to Santa, extract the name of the gift and the name' \
                               ' of the child  in the next format ' \
                               ' "the name of the gift is \"GIFT_NAME\" and the name of the child is \"CHILD_NAME\"'
        MODEL_ID = 'anthropic.claude-v2'

        def process_record(record)
          Logger.instance.info("Processing record: #{record.to_json}")

          received_message = JSON.parse(record['body'])

          completion = invoke_gift_and_username_discovery(received_message)
          discovered_gift_and_username_message = parse_bedrock_response(completion, received_message['connection_id'])
          return unless discovered_gift_and_username_message

          SendQueueMessage.new(message: discovered_gift_and_username_message.to_json, queue_url: ENV['GIFTS_QUEUE']).call
        end

        def client
          @client ||= Aws::BedrockRuntime::Client.new
        end

        def build_prompt(user_message)
          prompt = "#{ACT_AS_GIFT_DISCOVER}\n\n"\
                   "\n\nHuman: #{user_message}\n\nAssistant:"

          {
            prompt: prompt,
            max_tokens_to_sample: 300
          }
        end

        def invoke_gift_and_username_discovery(received_message)
          Logger.instance.info('Invoking bedrock to discover gift and username information')

          response = client.invoke_model(
            body: build_prompt(received_message['message']).to_json,
            model_id: MODEL_ID,
            content_type: 'application/json',
            accept: 'application/json'
          )
          response_body = response.body.read
          Logger.instance.info("Response: #{response_body}")

          JSON.parse(response_body)['completion']
        end

        def parse_bedrock_response(completion, connection_id)
          gift_pattern = /name of the gift is "(.*?)"/
          match_gift = completion.match(gift_pattern)

          username_pattern = /name of the child is "(.*?)"/
          match_username = completion.match(username_pattern)

          return unless match_gift && match_username && connection_id

          {
            gift: match_gift[1],
            username: match_username[1],
            connection_id: connection_id
          }
        end
      end
    end
  end
end
