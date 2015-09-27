require 'data_mapper'
class Header
  include DataMapper::Resource

  property :h_key, String
  property :value, String
  property :id, Serial
  property :report_id, Integer
end