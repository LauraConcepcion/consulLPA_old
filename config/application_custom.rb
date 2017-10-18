module Consul
  class Application < Rails::Application
    config.autoload_paths.unshift(Rails.root.join('lib/custom'))
  end
end
