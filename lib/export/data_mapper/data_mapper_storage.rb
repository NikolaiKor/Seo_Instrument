require 'data_mapper'
require_relative 'header'
require_relative 'report'
require_relative '../../model/site_info'
require_relative '../../model/result_list'
require_relative 'link'

module DataMapperExport
  class DataMapperStorage
    def initialize
      DataMapper.setup(:default, ENV['DATABASE_URL'] || App::Configuration.instance.data_mapper['database_url'])
      DataMapper.finalize
      DataMapper.auto_upgrade!
    end

    def all_reports(limited)
      _report_list = []
      _querry_params = {order: [:date.desc]}
      _querry_params[:limit] = App::Configuration.instance.main_page_limit if limited
      Report.all(_querry_params).each { |report| _report_list << ResultList.new(report.url, report.date, report.id) }
      {res_length: _report_list.length, res: _report_list}
    end

    def add_report(report)
      _params = {url: report.url.force_encoding("UTF-8"), title: report.title.force_encoding("UTF-8"), country: report.country.force_encoding("UTF-8"), date: report.date, ip: report.ip}
      _report = Report.new(_params)
      if _report.save
        _id = _report.id
        report.headers.each { |r_key, r_value| Header.new(:h_key => r_key, :value => r_value, :report_id => _id).save }
        report.links.each { |link| _link = Link.new(name: link.name, url: link.url, rel: link.rel, target: link.target, report_id: _id).save }
      end
    end

    def find_report(report_id)
      _headers = Hash.new
      _report = Report.first(id: report_id)
      Header.all(report_id: report_id).each { |h| _headers[h[:h_key]] =h[:value] }
      _result = SiteInfo.new(_report.url, _headers, _report.ip.to_s, _report.country, _report.date)
      _result.title = _report.title
      Link.all(report_id: report_id).each { |link| _result.add_link(link.name, link.url, link.rel, link.target) }
      _result
    end
  end
end