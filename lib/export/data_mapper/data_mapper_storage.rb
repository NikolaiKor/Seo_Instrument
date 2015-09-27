require 'data_mapper'
require_relative 'header'
require_relative 'report'
require_relative '../../model/site_info'
require_relative '../../model/result_list'
require_relative 'link_row'
require_relative '../json/json_storage'
class DataMapperStorage
  TYPE = 'data_mapper_storage'

  def initialize
    DataMapper.setup(:default, 'postgres://seo:seopass@localhost/seo_database')
    DataMapper.finalize
  end

  def all_reports
    _report_list = []
    Report.all.each { |report| _report_list << ResultList.new(report.url, report.date.strftime('%d.%m.%Y %H:%M:%S'), report.id) }
    {res_length: _report_list.length, res: _report_list}
  end

  def add_report(report)
    #Report.transaction do |t|
      _params = {url: report.url.force_encoding("UTF-8"), title: report.title.force_encoding("UTF-8"), country: report.country.force_encoding("UTF-8"), date: DateTime.parse(report.date), ip: report.ip}
      _report = Report.new(_params)
      _a =_report.save
      #_report.atributes(_params)
      _id = Report.first(_params)
      _id = _id.id
      report.headers.each { |r_key, r_value| Header.new(:h_key => r_key, :value => r_value, :report_id => _id).save }
      report.links.each { |link| _link = LinkRow.new(name: link.name, url: link.url, rel: link.rel, target: link.target, report_id: _id).save }
    #end
  end

  def find_report(report_id)
    _headers = Hash.new
    _report = Report.first(id: report_id)
    Header.all(report_id: report_id).each { |h| _headers[h[:h_key]] =h[:value] }
    _result = SiteInfo.new(_report.url, _headers, _report.ip.to_s, _report.country, _report.date.strftime('%d.%m.%Y %H:%M:%S'))
    _result.title = _report.title
    _a = LinkRow.all(report_id: report_id)
    _a.each do |link|
      _result.add_link(link.name, link.url, link.rel, link.target)
    end
    _result
  end

end
=begin
_test = DataMapperStorage.new
_test_storage = JsonStorage.new
_test_info = _test_storage.find_report "kpi.ua_22.09.2015 16:13:56.json"
# _test_info = SiteInfo.new('http://kk', {zz: 12}, '192.18.25.17', 'Ukraine', '2015-09-23 14:25:57.563001')
# _test_info.add_link(' ich ', ' http : // aa ', ' ', ' ')
# _test_info.title = 'kaizer'
_a = _test.add_report _test_info
=end
