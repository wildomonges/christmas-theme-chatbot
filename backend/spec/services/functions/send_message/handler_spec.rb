# spec/send_message_spec.rb

require 'spec_helper'
require 'send_message/handler'
require 'services/logger'
require 'services/send_queue_message'
require 'models/connection'

RSpec.describe ChristmasThemeChatbot::Functions::SendMessage do
  let(:event) do
    {
      'body' => { 'data' => 'test_message' }.to_json,
      'requestContext' => {
        'connectionId' => 'test_connection_id',
        'domainName' => 'test_domain',
        'stage' => 'test_stage'
      }
    }
  end
  let(:context) { {} }
  let(:logger) { ChristmasThemeChatbot::Layers::Shared::Services::Logger.instance }
  let(:connection) { ChristmasThemeChatbot::Layers::Shared::Models::Connection }
  let(:send_queue_message) { ChristmasThemeChatbot::Layers::Shared::Services::SendQueueMessage }

  describe '.handler' do
  end
end
