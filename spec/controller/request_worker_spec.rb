require 'rspec'
require 'fakeweb'
require './lib/controller/request_worker'

RSpec.describe App::RequestWorker do
  HTML_FILE = './spec/controller/Test.html'

  before(:all) do
    File.open(HTML_FILE, 'r') { |f| @html_page = f.read }
    FakeWeb.register_uri(:get, 'http://example.com', :body => @html_page, :content_type => 'text/html; charset=utf-8')
  end

  it 'send request to url with http' do
    _obj = App::RequestWorker.new
    _url = 'http://example.com'
    _report = _obj.send(:create_report, _url, nil)
    expect(_report.links[0].name).to eq('Example')
    expect(_report.links[1].name).to eq('Test')
    expect(_report.links[1].url).to eq('https://test.com/rspec')
    expect(_report.links[1].rel).to eq('details')
    expect(_report.links[0].target).to eq('_blank')
    expect(_report.links[1].target).not_to eq('_blank')

    expect(_report.title).to eq('Title')

    expect(_report.headers['content-type']).to eq('text/html; charset=utf-8')

  end

  it 'get domain name  from url without http://' do
    _obj = App::RequestWorker.new
    _url = 'example.com'
    _domain = _obj.domain_name(_url)
    expect(_domain).to eq(_url)
  end

  it 'send request to url with http://' do
    _obj = App::RequestWorker.new
    _url = 'http://example.com'
    _url2 = 'example.com'
    _domain = _obj.domain_name(_url)
    expect(_domain).to eq(_url2)
  end

  it 'get domain name to url with http:// and page' do
    _obj = App::RequestWorker.new
    _url = 'http://example.com/page.html'
    _url2 = 'example.com'
    _domain = _obj.domain_name(_url)
    expect(_domain).to eq(_url2)
  end

  it 'not cut short string' do
    _obj = App::RequestWorker.new
    _str = 'a' * (App::URL_PRIMARY_PROPERTIES_LENGTH/2)
    _str2 = _obj.send(:cut_string, _str)
    expect(_str2).to eq(_str)
  end

  it 'cut long string' do
    _obj = App::RequestWorker.new
    _str = 'a' * App::URL_PRIMARY_PROPERTIES_LENGTH
    _str2 = _obj.send(:cut_string, _str)
    expect(_str2).to eq(_str[0,_str.length-3]+'...')
    expect(_str2).not_to eq(_str)
  end

  it 'set title to report' do
    _obj = App::RequestWorker.new
    _title = 'Title'
    _report = SiteInfo.new(nil, nil, nil, nil, nil, nil)
    _obj.send(:set_title, @html_page, _report)
    expect(_report.title).to eq(_title)
  end

  it 'not normalise url with http://' do
    _obj = App::RequestWorker.new
    _url = 'http://example.com'
    _url_norm = _obj.send(:url_normalisation, _url)
    expect(_url_norm).to eq(_url)
  end

  it 'not normalise url https://' do
    _obj = App::RequestWorker.new
    _url = 'https://example.com'
    _url_norm = _obj.send(:url_normalisation, _url)
    expect(_url_norm).to eq(_url)
  end

  it 'normalise url without http://' do
    _obj = App::RequestWorker.new
    _url = 'example.com'
    _url2 = 'http://example.com'
    _url_norm = _obj.send(:url_normalisation, _url)
    expect(_url_norm).not_to eq(_url)
    expect(_url_norm).to eq(_url2)
  end

  it 'parse links to to report' do
    _obj = App::RequestWorker.new
    _report = SiteInfo.new(nil, nil, nil, nil, nil, nil)
    _obj.send(:parse_links, @html_page, _report)
    expect(_report.links[0].name).to eq('Example')
    expect(_report.links[1].name).to eq('Test')
    expect(_report.links[1].url).to eq('https://test.com/rspec')
    expect(_report.links[1].rel).to eq('details')
    expect(_report.links[0].target).to eq('_blank')
    expect(_report.links[1].target).not_to eq('_blank')
  end
end