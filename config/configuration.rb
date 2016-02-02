class Configuration
  attr_reader :storage_type
  def initialize
    @storage_type = :data_mapper_storage
    # @storage_type = :pg_database
    # @storage_type = :json
  end
end