# frozen_string_literal: true

require 'aws-sdk-sqs'
require 'services/logger'

module ChristmasThemeChatbot
  module Layers
    module Shared
      module Services
        # Handle send sqs message
        class SendQueueMessage
          include ChristmasThemeChatbot::Layers::Shared::Services

          attr_reader :sqs, :message, :queue_url

          # Construct the object  
          # @param queue_url [String] The URL of the queue.
          # @param message [String] The contents of the message to be sent.
          def initialize(message:, queue_url:)
            @sqs = Aws::SQS::Client.new

            @message = message
            @queue_url = queue_url
          end

          # Send message
          # @return [Hash] including message_id, sequence_number and fields mentioned here
          # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SQS/Client.html#send_message-instance_method
          def call
            return if queue_url.nil?

            Logger.instance.info("Sending message: #{message} to queue: #{queue_url}")

            response = sqs.send_message(
              queue_url: queue_url,
              message_body: message
            )

            Logger.instance.info("Response: #{response.to_json}")

            response
          end
        end
      end
    end
  end
end
