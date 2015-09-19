require_relative 'link'
#Include all info about site: url, headers, ip, country, hyperlinks.
class SiteInfo
  attr_reader :headers, :links, :ip, :country

  def initialize(url, headers, ip, country)
    @url = url
    @headers = headers
    @links = []
    @ip = ip
    @country = country
  end

  def add_link(name, url, rel, target)
    _link = Link.new(name, url, rel, target)
    @links << _link
  end

end