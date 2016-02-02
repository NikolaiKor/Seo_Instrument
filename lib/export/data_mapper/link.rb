require 'data_mapper'

module DataMapperExport
  class LinkRow
    include DataMapper::Resource
    storage_names[:default] = 'links'

    property :name, String, length: 255
    property :url, String, length: 100
    property :rel, String
    property :target, String
    property :id, Serial
    belongs_to :report
  end
end