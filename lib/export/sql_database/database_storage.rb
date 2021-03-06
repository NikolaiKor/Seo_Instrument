require_relative '../abstract_storage'
require 'pg'
require './lib/model/site_info'
require './lib/model/result_list'
require './lib/model/user'

module SQLExport
  class DatabaseStorage < App::AbstractStorage
    def initialize
      _config = App::Configuration.instance.postgres
      @connector = PG.connect(host: _config['host'], port: _config['port'], dbname: _config['dbname'], user: _config['user'], password: _config['password'])
      @connector.type_map_for_results = PG::BasicTypeMapForResults.new @connector
    end

    def add_report(report)
      _querry = "INSERT INTO reports (url, title, ip, country, date#{', user_id' unless report.user_id.nil?}) VALUES ($1, $2, $3, $4, $5#{', $6' unless report.user_id.nil?})
                        RETURNING id"
      _arr = [report.url, report.title, report.ip, report.country, report.date]
      _arr << report.user_id unless report.user_id.nil?
      @connector.transaction do |conn|
        _id = conn.exec(_querry, _arr)
        _links = report.links
        _headers = report.headers
        _id.each do |index|
          _links.each { |link| conn.exec('INSERT INTO links (name, url, rel, target, report_id) VALUES ($1, $2, $3, $4, $5)',
                                         [link.name, link.url, link.rel, link.target, index["id"]]) }
          _headers.each { |key, value| conn.exec('INSERT INTO headers (h_key, value, report_id) VALUES ($1, $2, $3)',
                                                 [key, value, index["id"]]) }
        end
      end
    end

    def all_reports(page, per_page, user_id)
      _id = user_id.nil? ? 'IS NULL' : "= #{user_id}"
      _query = "SELECT id, url, date FROM reports WHERE user_id #{_id} ORDER BY date DESC LIMIT #{per_page}"
      _query << " OFFSET #{per_page * (page - 1)}" if page > 1
      _report_list = []
      @connector.exec(_query).each { |res| _report_list << ResultList.new(res['url'], res['date'], res['id']) }
      {res_length: _report_list.length, res: _report_list}
    end

    def find_report(id)
      _result = nil
      @connector.exec('SELECT * FROM reports WHERE id = $1 LIMIT 1', [id]).each do |res|
        _buf_headers = @connector.exec('SELECT * from headers where report_id = $1::int', [id])
        _headers = Hash.new
        _buf_headers.each { |h| _headers[h['h_key']] = h['value'] }
        _result = SiteInfo.new(res['url'], _headers, res['ip'].to_s, res['country'], res['date'], res['user_id'])
        _buf_links = @connector.exec('SELECT * from links where report_id = $1::int ORDER BY id ASC', [res['id']])
        _buf_links.each { |link| _result.add_link(link['name'], link['url'], link['rel'], link['target']) }
        _result.title = res['title']
      end
      raise App::NoReportError.new('no report') if _result.nil?
      _result
    end

    def password_auth(username, password)
      _user = nil
      @connector.exec('SELECT id FROM users WHERE username = $1 AND password = $2 LIMIT 1', [username, password]).each do |res|
        _user = User.new(res['id'], username, password)
      end
      _user
    end

    def get_user_by_id(id)
      _user = nil
      @connector.exec('SELECT username, password FROM users WHERE id = $1 LIMIT 1', [id]).each do |res|
        _user = User.new(id, res['username'], res['password'])
      end
      _user
    end

    def destroy_report(report_id, user_id)
      @connector.exec('DELETE FROM reports WHERE id = $1 AND user_id = $2', [report_id, user_id])
    end
  end
end