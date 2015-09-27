require_relative '../abstract_storage'
require 'pg'
require_relative '../../model/site_info'
require_relative '../../model/result_list'
class Database_storage < AbstractStorage
  TYPE = 'pg_database'

  def initialize
    #host port options tty dbname user password
    @connector = PG.connect(host: 'localhost', port: 5432, dbname: 'seo_database', user: 'seo', password: 'seopass')
    @connector.type_map_for_results = PG::BasicTypeMapForResults.new @connector
  end

  def add_report(report)
    @connector.transaction do |conn|
      _id = conn.exec('INSERT INTO reports (url, title, ip, country, date) VALUES ($1, $2, $3, $4, $5)
                        RETURNING id', [report.url, report.title, report.ip, report.country, report.date])
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

  def all_reports
    _buf = @connector.exec('SELECT id, url,date FROM reports')
    _report_list = []
    _buf.each { |res| _report_list << ResultList.new(res["url"], res["date"].to_s, res["id"]) }
    {res_length: _report_list.length, res: _report_list}
  end

  def find_report(id)
    _buf = @connector.exec('SELECT * FROM reports WHERE id = $1 LIMIT 1', [id])
    _headers = Hash.new
    _result = nil
    _buf.each do |res|
      _buf_headers = @connector.exec("SELECT * from headers where report_id = $1::int", [id])
      _buf_headers.each { |h| _headers[h['h_key']] = h['value'] }
      _result = SiteInfo.new(res["url"], _headers, res["ip"].to_s, res["country"], res["date"])
      _buf_links = @connector.exec("SELECT * from links where report_id = $1::int", [res['id']])
      _buf_links.each { |link| _result.add_link(link["name"], link["url"], link["rel"], link["target"]) }
      _result.title = res["title"]
    end
    _result
  end

  # private
  #
  # _test = Database_storage.new
  # _test_info = SiteInfo.new('http://aa', {zz: 12}, '192.18.0.0', 'Ukraine', '2015-09-23 14:25:57.423001')
  # _test_info.add_link(' ich ', ' http : // aa ', ' ', ' ')
  # _test.add_report _test_info
end