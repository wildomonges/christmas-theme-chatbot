# frozen_string_literal: true

require 'dotenv/load'
require 'dynamoid'

Dynamoid.configure do |config|
  config.namespace = nil # to avoid having the prefix dynamoid_ as part of the table name
end

module ChristmasThemeChatbot
  module Layers
    module Shared
      module Models
        # This class is used to interact with dynamodb connections table
        class Gift
          include Dynamoid::Document

          table name: ENV['GIFTS_TABLE']

          field :connectionId
          field :username
          field :gift

          validates_presence_of :connectionId, :username, :gift
        end
      end
    end
  end
end
