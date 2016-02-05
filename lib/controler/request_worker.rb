require 'net/http'
require 'geoip'
require 'nokogiri'
require 'httparty'
require_relative '../model/site_info'
require_relative '../model/link'
require './lib/export/storage_factory'

module App
#Send Get request to url, and parse it
  class RequestWorker
    GEO_IP_FILE = './lib/controler/GeoIP.dat'

    def get_info(url)
      _url_copy = url_normalisation(url)
      _response = send_request(_url_copy)
      _geo = GeoIP.new(GEO_IP_FILE).country(domain_name(url))
      _headers = Hash.new()
      _response.headers.each { |key, value| _headers[cut_string(key)] = cut_string(value) }
      _info = SiteInfo.new(cut_string(_url_copy), _headers, _geo.ip, _geo.country_name, Time.now)
      parse_links(_response.body, _info)
      set_title(_response.body, _info)
      _info.identifier = "#{_info.domain}_#{_info.date.strftime(Configuration.instance.time_format)}"
      StorageFactory.new.get_connector.add_report(_info)
      _info
    end

    def domain_name(url)
      _url_copy = url.clone
      _position = _url_copy.index('//')
      _url_copy[0, _position+2] = '' if _position
      _position = _url_copy.index('/')
      _url_copy = _url_copy[0, _position] if _position
      _url_copy
    end

    def get_reports_list(limited = false)
      StorageFactory.new.get_connector.all_reports(limited)
    end

    def get_report(file_id)
      StorageFactory.new.get_connector.find_report(file_id)
    end

    private

    def url_normalisation(url)
      _url_copy = url.clone
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
      _links.each { |link| info.add_link(cut_string(link.text), cut_string(link['href']),
                                         link['rel'], link['target']) } unless _links.nil?
    end

    def set_title(body, info)
      _doc = Nokogiri::HTML(body)
      info.title = cut_string(_doc.css('title').text)
    end

    def cut_string(str)
      return '' if str.nil?
      str.length < URL_PRIMARY_PROPERTIES_LENGTH ? str : str[0, URL_PRIMARY_PROPERTIES_LENGTH-3]+'...'
    end
  end
end