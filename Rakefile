require "contentful/management"
require "faraday"
require "json"

# Modules
require_relative("app/modules/contentful/module.management.rb")
require_relative("app/modules/chartable/module.chartable.rb")

# Chartable tasks
namespace :chartable do

  include Contentful::Management
  include Chartable

  desc "Chartable - Import Podcast Downloads"
  task :import do

    verify_env

    update_episode_downloads

  end

end