require 'rspec'
require './lib/export/data_mapper/data_mapper_storage'
require 'support/db_export_example'
require 'support/db_cleaner_example'
require 'fileutils'

RSpec.describe JsonExport::JsonStorage do
  before(:all) do
    @db = JsonExport::JsonStorage.new
    @report = create_test_report
    Dir.mkdir(App::Configuration.instance.json['base_dir']) unless File.exists?(App::Configuration.instance.json['base_dir'])
  end

  after(:all) do
    FileUtils.rm_r(App::Configuration.instance.json['base_dir'])
  end

  it 'save report, read it and compare' do
    @db.add_report(@report)
    _report = @db.find_report("example.com_#{@report.date.strftime('%d.%m.%Y %H:%M:%S')}.json")
    expect(_report.links[0].name).to eq(@report.links[0].name)
    expect(_report.links[1].name).to eq(@report.links[1].name)
    expect(_report.links[1].url).to eq(@report.links[1].url)
    expect(_report.links[1].rel).to eq(@report.links[1].rel)
    expect(_report.links[0].target).to eq(@report.links[0].target)
    expect(_report.links[1].target).not_to eq(@report.links[0].target)

    expect(_report.title).to eq(@report.title)

    expect(_report.headers['content-type']).to eq('text/html; charset=utf-8')
  end

  it 'save 2 report as guest, get all reports and check reports number' do
    @db.add_report(create_test_report)
    _buf_report = create_test_report
    _buf_report.instance_variable_set(:@date, Time.now)
    @db.add_report(_buf_report)
    _reports = @db.all_reports(1, 10, nil)
    expect(_reports[:res_length]).to eq(_reports[:res].length)
    expect(_reports[:res_length]).to eq(2)
  end
end