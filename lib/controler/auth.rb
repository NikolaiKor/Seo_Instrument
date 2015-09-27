require_relative '../model/user'
require 'warden'
require_relative '../application'
Warden::Strategies.add(:password) do
  def valid?
    params['user_name'] && params['user_password']
  end

  def authenticate!
    user = User.first(username: params['user_name'])

    if user.nil?
      throw(:warden, err:"The username does not exist.")
    elsif user.authenticate(params['user_password'])
      success!(user)
    else
      throw(:warden, err:"Could not log in")
    end
  end
end

use Warden::Manager do |config|
  # Tell Warden how to save our User info into a session.
  # Sessions can only take strings, not Ruby code, we'll store
  # the User's `id`
  config.serialize_into_session { |user| user.id }
  # Now tell Warden how to take what we've stored in the session
  # and get a User from that information.
  config.serialize_from_session { |id| User.get(id) }

  config.scope_defaults :default,
                        # "strategies" is an array of named methods with which to
                        # attempt authentication. We have to define this later.
                        strategies: [:password],
                        # The action is a route to send the user to when
                        # warden.authenticate! returns a false answer. We'll show
                        # this route below.
                        action: 'auth/unauthenticated'
  # When a user tries to log in and cannot, this specifies the
  # app to send the user to.
  config.failure_app = App::Application
end

Warden::Manager.before_failure do |env, opts|
  env['REQUEST_METHOD'] = 'POST'
end