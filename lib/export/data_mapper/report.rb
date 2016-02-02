require 'data_mapper'

module DataMapperExport
  class Report
    include DataMapper::Resource
    storage_names[:default] = 'reports'

    property :id, Serial
    property :url, String
    property :title, String
    property :ip, String
    property :country, String
    property :date, DateTime
  end
end