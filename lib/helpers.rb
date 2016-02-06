module App
  helpers do
    def current_user_id
      env['warden'].user.nil? ? nil : env['warden'].user.id
    end

    def current_user_name
      env['warden'].user.nil? ? nil : env['warden'].user.name
    end

    def reports_list(user_id = nil)
      _page = @params[:page].to_i
      _page = 1 if _page <= 0
      _per_page = @params[:per_page].to_i
      _per_page = Configuration.instance.per_page_default if _per_page <= 0
      RequestWorker.new.get_reports_list(_page, _per_page, user_id)
    end
  end
end