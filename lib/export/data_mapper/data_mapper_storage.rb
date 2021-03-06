require 'data_mapper'
require_relative 'header'
require_relative 'report'
require './lib/model/site_info'
require './lib/model/result_list'
require_relative 'link'
require_relative 'user'
require './lib/model/user'
require './lib/controller/no_report_error'
module DataMapperExport
  class DataMapperStorage
    def initialize
      DataMapper.setup(:default, ENV['DATABASE_URL'] || App::Configuration.instance.data_mapper['database_url'])
      DataMapper.finalize
      DataMapper.auto_upgrade!
    end

    def all_reports(page, per_page, user_id)
      _report_list = []
      _querry_params = {order: [:date.desc], limit: per_page, user_id: user_id}
      _querry_params[:offset] = per_page * (page - 1) if page > 1

      Report.all(_querry_params).each { |report| _report_list << ResultList.new(report.url, report.date, report.id) }
      {res_length: _report_list.length, res: _report_list}
    end

    def add_report(report)
      _report = Report.new(url: report.url.force_encoding("UTF-8"), title: report.title.force_encoding("UTF-8"), country: report.country.force_encoding("UTF-8"), date: report.date, ip: report.ip, user_id: report.user_id)
      if _report.save
        _id = _report.id
        report.headers.each { |r_key, r_value| Header.new(:h_key => r_key, :value => r_value, :report_id => _id).save }
        report.links.each { |link| _link = Link.new(name: link.name, url: link.url, rel: link.rel, target: link.target, report_id: _id).save }
      end
    end

    def find_report(report_id)
      _report = Report.first(id: report_id)
      raise App::NoReportError.new('no report') if _report.nil?
      _headers = Hash.new
      Header.all(report_id: report_id).each { |h| _headers[h[:h_key]] =h[:value] }
      _result = SiteInfo.new(_report.url, _headers, _report.ip.to_s, _report.country, _report.date, _report.user_id)
      _result.title = _report.title
      Link.all(report_id: report_id).each { |link| _result.add_link(link.name, link.url, link.rel, link.target) }
      _result
    end

    def destroy_report(report_id, user_id)
      _report = Report.first(id: report_id, user_id: user_id)
      _report.destroy unless _report.nil?
    end

    def password_auth(username, password)
      _db_user = User.first(username: username, password: password)
      ::User.new(_db_user.id, username, password) unless _db_user.nil?
    end

    def get_user_by_id(id)
      _db_user = User.first(id: id)
      ::User.new(id, _db_user.username, _db_user.password) unless _db_user.nil?
    end
  end
end