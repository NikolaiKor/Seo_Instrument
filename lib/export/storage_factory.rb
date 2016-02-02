require_relative '../../config/configuration'
require_relative 'json/json_storage'
require_relative 'sql_database/database_storage'
require_relative 'data_mapper/data_mapper_storage'

module App
  class StorageFactory
    def get_connector
      @connector ||= init_connector
    end

    def init_connector
      _type = Configuration.new.storage_type
      case
        when _type == :json then
          return JsonExport::JsonStorage.new
        when _type == :pg_database then
          return SQLExport::DatabaseStorage.new
        when _type == :data_mapper_storage then
          return DataMapperExport::DataMapperStorage.new
      end
    end
  end
end