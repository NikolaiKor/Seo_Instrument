module App
  URL_PRIMARY_PROPERTIES_LENGTH = 255

  class AbstractStorage
    def all_reports(limited);end
    def add_report(report);end
    def find_report(report_id);end
    def destroy_report(report_id, user_id); end
    def password_auth(username, password);end
    def get_user_by_id(id);end
  end
end