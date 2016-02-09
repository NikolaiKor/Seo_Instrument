#require ::File.expand_path('../config/environment',  __FILE__)
require './lib/application'
require 'slim'
require './lib/controller/warden/config'
require_relative 'lib/configuration/configuration'

run App::Application
