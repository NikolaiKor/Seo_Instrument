class ResultList
  attr_reader :url, :time, :view
  def initialize(url, time, view)
    @url = url
    @time = time
    @view = view
  end
end