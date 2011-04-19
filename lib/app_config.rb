require 'yaml'
require 'ostruct'

config = YAML.load_file(File.join(Rails.root, "config", "config.yml")) || {}
app_config = config['common'] || {}
app_config.update(config[Rails.env] || {})

AppConfig = OpenStruct.new(app_config)
