# spec/on_disconnect_spec.rb

require 'spec_helper'
require 'on_disconnect/handler'
require 'models/connection'


RSpec.describe ChristmasThemeChatbot::Functions::OnDisconnect do
  let(:connection_id) { 'test_connection_id' }
  let(:event) { { 'requestContext' => { 'connectionId' => connection_id } } }
  let(:context) { {} }
  let(:logger) { ChristmasThemeChatbot::Layers::Shared::Services::Logger.instance }
  let(:connection) { ChristmasThemeChatbot::Layers::Shared::Models::Connection }

  describe '.handler' do
    context 'when connection exists' do
      before do
        allow(logger).to receive(:info) # Stub logger
        allow(connection).to receive(:find).with(connection_id).and_return(double('connection', delete: nil))
      end

      it 'deletes the existing connection and returns a success response' do
        expect(logger).to receive(:info).with("Handle onDisconnect. Event: #{event.to_json}")
        expect(logger).to receive(:info).with("ConnectionId: #{connection_id}")
        expect(connection).to receive(:find).with(connection_id)
        expect(logger).to receive(:info).with("Connection #{connection_id} deleted")

        response = described_class.handler(event: event, context: context)

        expect(response).to eq({ statusCode: 204, body: '' })
      end
    end

    context 'when connection does not exist' do
      before do
        allow(logger).to receive(:info) # Stub logger
        allow(connection).to receive(:find).with(connection_id).and_return(nil)
      end

      it 'does not attempt to delete a non-existing connection and returns a success response' do
        expect(logger).to receive(:info).with("Handle onDisconnect. Event: #{event.to_json}")
        expect(logger).to receive(:info).with("ConnectionId: #{connection_id}")
        expect(connection).to receive(:find).with(connection_id).and_return(nil)
        expect(logger).not_to receive(:info).with("Connection #{connection_id} deleted")

        response = described_class.handler(event: event, context: context)

        expect(response).to eq({ statusCode: 500, body: 'We are sorry but something wrong happened! Try again later' })
      end
    end
  end
end
