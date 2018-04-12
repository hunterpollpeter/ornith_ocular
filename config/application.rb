require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrnithOcular
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    case Rails.env
      when "development"
        config_files = ['secrets.yml']
    end

    config_files.each do |file_name|
      file_path = File.join(Rails.root, 'config', file_name)
      if (File.exist?(file_path)) then
        config_keys = HashWithIndifferentAccess.new(YAML::load(IO.read(file_path)))[Rails.env]
          config_keys.each do |k,v|
          ENV[k.upcase] ||= v
        end
      end
    end    
  end
end