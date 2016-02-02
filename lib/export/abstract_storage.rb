module App
  class AbstractStorage
    TYPE = 'abstract'
    URL_PRIMARY_PROPERTIES_LENGTH = 255

    def all_reports;end
    def add_report(report);end
    def find_report(report_id);end
  end
end