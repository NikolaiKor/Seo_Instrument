require 'net/http'
require 'geoip'
require 'nokogiri'
require 'httparty'
require '../model/site_info'
require '../model/link'
#Send Get request to url, and parse it
class RequestWorker
  GEO_IP_FILE = 'GeoIP.dat'

  def send_request(url)
    _url_copy = url
    'http://' << url_copy if url['://'].nil?
    HTTParty.get(_url_copy)
  end

  def domain_name(url)
    _url_copy = url
    _position = _url_copy.index('//')
    _url_copy[0, _position+2] = '' if _position
    _position = _url_copy.index('/')
    _url_copy = _url_copy[0, _position] if _position
    _url_copy
  end

  def get_info(url)
    _response = send_request(url)
    _geo =GeoIP.new(GEO_IP_FILE).country(domain_name(url))
    _headers = Hash.new()
    _response.headers.each { |key, value| _headers[key] = value }
    _info = SiteInfo.new(url, _headers, _geo.ip, _geo.country_name)
    #print _info.inspect
    parse_links _response.body, _info
    _info
  end

  def parse_links(body, info)
    _doc = Nokogiri::HTML(body)
    _links = _doc.css('a')
    _links.each { |link| info.add_link(link.text, link['href'],
                                       link['rel'], link['target']) } unless _links.nil?
  end
end