class SiteInfo
  attr_reader :headers, :links, :ip, :country

  def initialize( url, headers, ip, country)
    @url = url
    @headers = headers
    @links = []
    @ip = ip
    @country = country
  end

  def add_link(name, url, rel, target)
    @links << Link.new(name, url, rel, target)
  end

end