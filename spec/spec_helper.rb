require 'rack/test'
require 'rspec'
require 'database_cleaner'
require './lib/configuration/configuration'

require File.expand_path '../../lib/application.rb', __FILE__
Dir['./spec/support/**/*.rb'].sort.each {|f| require f}

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }

RSpec.configure do |config|
  config.before(:suite) do
    App::Configuration.instance.load_config('test_config.yaml')
    DataMapperExport::DataMapperStorage.new
    DatabaseCleaner.strategy = :transaction
  end
end

def create_test_report(user_id = nil)
  _headers = {'content-type' => 'text/html; charset=utf-8'}
  _info = SiteInfo.new('http://example.com', _headers, '127.0.0.1', 'Ukraine', Time.new(2002, 10, 31, 2, 2, 2, '+02:00'), user_id)
  _info.add_link('Example', 'https://example.com', nil, '_blank')
  _info.add_link('Test', 'https://test.com/rspec', rel='details', nil)
  _info.title = 'Title'
  _info.identifier = "#{_info.domain}_#{_info.date.strftime(App::Configuration.instance.time_format)}"
  _info
end