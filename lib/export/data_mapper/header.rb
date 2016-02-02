require 'data_mapper'

class Header
  include DataMapper::Resource

  property :h_key, String
  property :value, String
  property :id, Serial
  belongs_to :report
end