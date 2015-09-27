require 'sequel'
require_relative 'abstract_storage'
require_relative '../../lib/model/result_list'
class SequelDatabase < AbstractStorage
  def initialize
    @connector = Sequel.postgres(host: 'localhost', port: 5432, database: 'seo_database', user: 'seo', password: 'seopass')
  end

  def all_reports
    _a =Report.all
    print a
  end
  def add_report(report); end
  def find_report(report_id); end

  _test = SequelDatabase.new
  _test.all_reports

  class Report < Sequel::Model;end
  class Header < Sequel::Model;end
  class Link < Sequel::Model;end
end