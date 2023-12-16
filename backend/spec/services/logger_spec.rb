# spec/logger_spec.rb

require 'spec_helper'
require 'services/logger'

RSpec.describe ChristmasThemeChatbot::Layers::Shared::Services::Logger do
  let(:logger) { described_class.instance }

  describe '#info' do
    it 'prints an info message' do
      expect { logger.info('Test info message') }.to output("INFO: Test info message\n").to_stdout
    end
  end

  describe '#warn' do
    it 'prints a warning message' do
      expect { logger.warn('Test warning message') }.to output("WARN: Test warning message\n").to_stdout
    end
  end

  describe '#error' do
    it 'prints an error message' do
      expect { logger.error('Test error message') }.to output("ERROR: Test error message\n").to_stdout
    end
  end
end
