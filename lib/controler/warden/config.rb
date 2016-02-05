require './lib/model/user'
require 'warden'
require './lib/application'
require_relative 'password_strategy'

use Rack::Session::Cookie, :secret => "secret key"

use Warden::Manager do |config|
  config.serialize_into_session { |user| user.id }
  config.serialize_from_session { |id| User.get(id)}
  # config.default_scope = :user

  config.scope_defaults :default, strategies: [:password], action: 'auth/unauthenticated'
  config.failure_app = App::Application
end

Warden::Manager.before_failure do |env, opts|
  env['REQUEST_METHOD'] = 'POST'
end