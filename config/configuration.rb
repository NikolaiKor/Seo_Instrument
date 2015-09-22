class Configuration
  attr_reader :storage_type
  def initialize
    @storage_type = :json
  end
end