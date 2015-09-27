require 'data_mapper'
class Report
  include DataMapper::Resource

  property :id, Serial
  property :url, String
  property :title, String
  property :ip, String
  property :country, String
  property :date, DateTime
end