#require ::File.expand_path('../config/environment',  __FILE__)
require './lib/application'
require 'slim'
require './lib/controler/auth'

DataMapperStorage.new
run App::Application
