require 'spec_helper'

RSpec.shared_examples 'db_cleaner_example' do
  before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  before(:each) do
    DatabaseCleaner.start
  end

  after(:each) do
    DatabaseCleaner.clean
  end
end