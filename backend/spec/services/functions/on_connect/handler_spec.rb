# spec/on_connect_spec.rb

require 'spec_helper'
require 'on_connect/handler'
require 'services/logger'
require 'models/connection'

RSpec.describe ChristmasThemeChatbot::Functions::OnConnect do
  let(:connection_id) { 'test_connection_id' }
  let(:event) { { 'requestContext' => { 'connectionId' => connection_id } } }
  let(:context) { {} }
  let(:logger) { ChristmasThemeChatbot::Layers::Shared::Services::Logger.instance }
  let(:connection) { ChristmasThemeChatbot::Layers::Shared::Models::Connection }

  describe '.handler' do
    it 'creates a new connection and returns a success response' do
      expect(logger).to receive(:info).with("Handle event onConnect. Event: #{event.to_json}")
      expect(logger).to receive(:info).with("ConnectionId: #{connection_id}")
      expect(connection).to receive(:create).with(connectionId: connection_id)
      expect(logger).to receive(:info).with('New connection created')

      response = described_class.handler(event: event, context: context)

      expect(response).to eq({ statusCode: 200, body: 'Successfully created a new connection' })
    end
  end
end
