require 'data_mapper'
class LinkRow
  include DataMapper::Resource
  storage_names[:legacy] = 'link'

  property :name, String
  property :url, String
  property :rel, String
  property :target, String
  property :id, Serial
  property :report_id, Integer
end