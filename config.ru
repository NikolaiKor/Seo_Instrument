#require ::File.expand_path('../config/environment',  __FILE__)
require './lib/application'
require 'slim'
require './lib/controler/auth'
require_relative 'lib/configuration/configuration'

App::Configuration.instance.load
run App::Application
