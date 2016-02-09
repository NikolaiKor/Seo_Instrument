require 'rspec'
require './lib/export/data_mapper/data_mapper_storage'
require 'support/db_export_example'
require 'support/db_cleaner_example'

RSpec.describe SQLExport::DatabaseStorage do
  include_examples 'db_export_example', SQLExport::DatabaseStorage
  include_examples 'db_cleaner_example'
end