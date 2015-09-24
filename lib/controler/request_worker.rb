require 'net/http'
require 'geoip'
require 'nokogiri'
require 'httparty'
require_relative '../model/site_info'
require_relative '../model/link'
require_relative '../../lib/export/storage_factory'
#Send Get request to url, and parse it
class RequestWorker
  GEO_IP_FILE = './lib/controler/GeoIP.dat'

  def get_info(url)
    _url_copy = url_normalisation(url)
    _response = send_request(_url_copy)
    _geo =GeoIP.new(GEO_IP_FILE).country(domain_name(url))
    _headers = Hash.new()
    _response.headers.each { |key, value| _headers[key] = value }
    _info = SiteInfo.new(_url_copy, _headers, _geo.ip, _geo.country_name, Time.now.strftime("%d.%m.%Y %H:%M:%S"))
    parse_links(_response.body, _info)
    set_title(_response.body, _info)
    _info.identifier = "#{_info.domain}_#{_info.date}"
    StorageFactory.new.get_connector.add_report(_info)
    _info
  end


  def domain_name(url)
    _url_copy = url
    _position = _url_copy.index('//')
    _url_copy[0, _position+2] = '' if _position
    _position = _url_copy.index('/')
    _url_copy = _url_copy[0, _position] if _position
    _url_copy
  end

  def get_reports_list
    StorageFactory.new.get_connector.all_reports
  end

  def get_report(file_id)
    StorageFactory.new.get_connector.find_report(file_id)
  end

  private

  def url_normalisation(url)
    _url_copy = url
     _url_copy ='http://' + _url_copy if url['http://'].nil? && url['https://'].nil?
    _url_copy
  end

  def send_request(url)
    _url_copy = url
    'http://' << _url_copy if url['://'].nil?
    HTTParty.get(_url_copy)
  end

  def parse_links(body, info)
    _doc = Nokogiri::HTML(body)
    _links = _doc.css('a')
    _links.each { |link| info.add_link(link.text, link['href'],
                                       link['rel'], link['target']) } unless _links.nil?
  end

  def set_title(body, info)
    _doc = Nokogiri::HTML(body)
    info.title = _doc.css('title').text
  end
end