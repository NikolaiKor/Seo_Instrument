require 'data_mapper'

module DataMapperExport
  class Header
    include DataMapper::Resource
    storage_names[:default] = 'headers'

    property :h_key, String
    property :value, String
    property :id, Serial
    belongs_to :report
  end
end