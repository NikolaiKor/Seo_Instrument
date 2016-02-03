module App
  URL_PRIMARY_PROPERTIES_LENGTH = 255

  class AbstractStorage
    def all_reports;end
    def add_report(report);end
    def find_report(report_id);end
  end
end