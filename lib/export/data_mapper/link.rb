require 'data_mapper'

module DataMapperExport
  class Link
    include DataMapper::Resource
    storage_names[:default] = 'links'

    property :name, String, length: App::URL_PRIMARY_PROPERTIES_LENGTH
    property :url, String, length: App::URL_PRIMARY_PROPERTIES_LENGTH
    property :rel, String
    property :target, String
    property :id, Serial
    belongs_to :report
  end
end