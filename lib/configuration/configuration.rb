require 'yaml'

module App
  class Configuration
    BASE_DIR = './config/'

    def self.instance
      @@instance ||= new
    end

    def load_config(file_name = 'configuration.yaml')
      YAML.load_file(BASE_DIR + file_name).each do |key, val|
        self.instance_variable_set("@#{key}", val)
        singleton_class.class_eval { attr_reader key.to_sym }
      end
    end

    private
    def initialize
      load_config
    end
  end
end