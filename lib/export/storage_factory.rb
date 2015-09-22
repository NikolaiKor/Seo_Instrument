require_relative '../../config/configuration'
require_relative 'json_storage'
require_relative 'database_storage'
class StorageFactory
  def get_connector
    @connector = init_connector if @connector.nil?
    @connector
  end

  def init_connector
    _type = Configuration.new.storage_type
    case
      when _type == :json then return JsonStorage.new
      when _type == :pg_database then return Database_storage.new
    end
  end


end