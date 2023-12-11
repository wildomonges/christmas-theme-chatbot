# frozen_string_literal: true

require 'singleton'

module ChristmasThemeChatbot
  module Layers
    module Shared
      module Services
        # This class is used to log to CloudWatch
        class Logger
          include Singleton

          def info(message)
            puts "INFO: #{message}"
          end

          def warn(message)
            puts "WARN: #{message}"
          end

          def error(message)
            puts "ERROR: #{message}"
          end
        end
      end
    end
  end
end
