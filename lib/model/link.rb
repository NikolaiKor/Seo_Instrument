#Include array of hyperlinks from site
class Link
  attr_reader :name, :url, :rel, :target

  def initialize(name, url, rel, target)
    name.nil? ? @name = name : @name = ''
    url.nil? ? @url = url : @url = ''
    rel.nil? ? @rel = rel : @rel = ''
    target.nil? ? @target = target : @target = ''
  end
end