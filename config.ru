#require ::File.expand_path('../config/environment',  __FILE__)
require './lib/application'
require 'slim'

run App::Application