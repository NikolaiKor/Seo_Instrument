#Include array of hyperlinks from site
class Link
  attr_reader :name, :url, :rel, :target

  def initialize(name, url, rel, target)
    name.nil? ? @name = '' : @name = name
    url.nil? ? @url = '' : @url = url
    rel.nil? ?  @rel = '' : @rel = rel
    target.nil? ? @target = '' : @target = target
  end

  def to_json(*a)
    {
        "json_class"   => self.class.name,
        "data"         => {"url" => @url, "name" => @name, "rel" => @rel, "target" => @target }
    }.to_json(*a)
  end

  def self.json_create(o)
    new(o["data"]["name"], o["data"]["url"], o["data"]["rel"], o["data"]["target"])
  end
end