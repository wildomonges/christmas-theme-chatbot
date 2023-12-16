# spec/send_queue_message_spec.rb

require 'spec_helper'
require 'services/send_queue_message'
require 'services/logger'

RSpec.describe ChristmasThemeChatbot::Layers::Shared::Services::SendQueueMessage do

  let(:message) { 'Test Message' }
  let(:queue_url) { 'https://sqs.example.com/queue' }
  let(:logger) { ChristmasThemeChatbot::Layers::Shared::Services::Logger.instance }
  

  describe '#call' do
    context 'when the queue_url is provided' do
      let(:send_queue_message) do
        described_class.new(message: message, queue_url: queue_url)
      end
      it 'sends a message to the specified queue' do
        allow(send_queue_message.sqs).to receive(:send_message).and_return(
          message_id: '123',
          sequence_number: '456',
          md5_of_message_body: 'abc'
        )

        expect(logger).to receive(:info).with("Sending message: #{message} to queue: #{queue_url}")
        expect(logger).to receive(:info).with(/Response:.*message_id.*sequence_number.*md5_of_message_body/)

        result = send_queue_message.call

        expect(result).to include(
          message_id: '123',
          sequence_number: '456',
          md5_of_message_body: 'abc'
        )
      end
    end

    context 'when the queue_url is nil' do
      let(:send_queue_message) do
        described_class.new(message: message, queue_url: nil)
      end

      it 'does not send a message and returns nil' do
        expect(send_queue_message.sqs).not_to receive(:send_message)
        expect(logger).not_to receive(:info)

        result = send_queue_message.call

        expect(result).to be_nil
      end
    end
  end
end
