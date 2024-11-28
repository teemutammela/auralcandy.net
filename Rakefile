# frozen_string_literal: true

require 'active_support/core_ext/hash'
require 'contentful/management'
require 'date'
require 'dotenv/load'
require 'faraday'

require_relative('app/modules/contentful/management')
require_relative('app/modules/podcast/statistics')

namespace :statistics do
  include Contentful::Management
  include Statistics

  desc 'Fetch episode downloads from OP3 API and update to Contentful'
  task :update_episode_downloads, [:start_date] do |_task, args|
    update_episode_downloads(args[:start_date])
  end
end
