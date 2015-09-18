class Link
  attr_reader :name, :url, :rel, :target

  def init(name, url, rel, target)
    @name = name
    @url = url
    @rel = rel
    @target = target
  end
end