source 'http://rubygems.org'

gem 'rack'
gem 'rack-contrib', '~> 1.1.0'
gem 'rake', '~> 0.9.2'
gem 'thin', '~>1.6'
gem 'sinatra'
gem 'slim'
gem 'geoip'
gem 'nokogiri', '~>1.6.6.2'
gem 'httparty'

group :test do
  #gem 'rspec', '~> 2.7.0'
  gem 'rack-test', '~> 0.6.0'
  gem 'fakeweb', '~> 1.3'
end

%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  gem lib, :git => "git://github.com/rspec/#{lib}.git", :branch => 'master'
end
