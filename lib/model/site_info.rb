require_relative 'link'
#Include all info about site: url, headers, ip, country, hyperlinks.
class SiteInfo
  attr_reader :headers, :links, :ip, :country, :url, :domain, :date
  attr_accessor :title

  def initialize(url, headers, ip, country, domain, date)
    @url = url
    @title = ''
    @headers = headers
    @links = []
    @ip = ip
    @country = country
    @domain = domain
    @date = date
  end

  def add_link(name, url, rel, target)
    _link = Link.new(name, url, rel, target)
    @links << _link #unless name == '' && (url == nil || url == '') && rel == nil && target == nil
  end

  def to_json(*a)
    {
        "json_class"   => self.class.name,
        "data"         => {"url" => @url, "title" => @title, "headers" => @headers, "links" => @links, "ip" => @ip, "country" => @country, "domain" => @domain, "date" => @date }
    }.to_json(*a)
  end

  def self.json_create(o)
    _res = new(o["data"]["url"], o["data"]["headers"], o["data"]["ip"], o["data"]["country"], o["data"]["domain"], o["data"]["date"])
    o["data"]["links"].each {|link| _res.add_link(link.name, link.url, link.rel, link.target)}
    _res.title = o["data"]["title"]
    _res
  end

end