require_relative 'link'
#Include all info about site: url, headers, ip, country, hyperlinks.
class SiteInfo
  attr_reader :headers, :links, :ip, :country, :url, :domain, :date
  attr_accessor :title

  def initialize(url, headers, ip, country, domain)
    @url = url
    @title = ''
    @headers = headers
    @links = []
    @ip = ip
    @country = country
    @domain = domain
    @date = Time.now.strftime("%d.%m.%Y %H:%M:%S")
  end

  def add_link(name, url, rel, target)
    _link = Link.new(name, url, rel, target)
    @links << _link #unless name == '' && (url == nil || url == '') && rel == nil && target == nil
  end

end