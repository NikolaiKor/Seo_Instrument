class Configuration
  attr_reader :storage_type
  def initialize
    @storage_type = :pg_database
  end
end