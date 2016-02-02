require_relative '../../config/configuration'
require_relative 'json/json_storage'
require_relative 'sql_database/database_storage'
require_relative 'data_mapper/data_mapper_storage'

class StorageFactory
  def get_connector
    @connector ||= init_connector
    # @connector
  end

  def init_connector
    _type = Configuration.new.storage_type
    case
      when _type == :json then
        return JsonStorage.new
      when _type == :pg_database then
        return Database_storage.new
      when _type == :data_mapper_storage then
        return DataMapperStorage.new
    end
  end


end