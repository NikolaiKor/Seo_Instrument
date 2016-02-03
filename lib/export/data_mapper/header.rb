require 'data_mapper'

module DataMapperExport
  class Header
    include DataMapper::Resource
    storage_names[:default] = 'headers'

    property :h_key, String
    property :value, String, length: App::URL_PRIMARY_PROPERTIES_LENGTH
    property :id, Serial
    belongs_to :report
  end
end