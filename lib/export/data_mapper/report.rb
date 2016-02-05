require 'data_mapper'

module DataMapperExport
  class Report
    include DataMapper::Resource
    storage_names[:default] = 'reports'

    property :id, Serial
    property :url, String, length: App::URL_PRIMARY_PROPERTIES_LENGTH
    property :title, String, length: App::URL_PRIMARY_PROPERTIES_LENGTH
    property :ip, String
    property :country, String
    property :date, DateTime
    property :user_id, Integer
  end
end