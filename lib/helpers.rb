module App
  helpers do
    def current_user_id
      env['warden'].user.nil? ? nil : env['warden'].user.id
    end

    def current_user_name
      env['warden'].user.nil? ? nil : env['warden'].user.name
    end
  end
end