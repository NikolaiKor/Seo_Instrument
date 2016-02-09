require 'spec_helper'

RSpec.shared_examples 'db_export_example' do |db_class|
  before(:all) do
    @db = db_class.new
    @report = create_test_report
  end

  it 'save report, read it and compare' do
    @db.add_report(@report)
    _report = @db.find_report(1)
    expect(_report.links[0].name).to eq(@report.links[0].name)
    expect(_report.links[1].name).to eq(@report.links[1].name)
    expect(_report.links[1].url).to eq(@report.links[1].url)
    expect(_report.links[1].rel).to eq(@report.links[1].rel)
    expect(_report.links[0].target).to eq(@report.links[0].target)
    expect(_report.links[1].target).not_to eq(@report.links[0].target)

    expect(_report.title).to eq(@report.title)

    expect(_report.headers['content-type']).to eq('text/html; charset=utf-8')
  end

  it 'save 2 report as user, get all reports and check reports number' do
    @db.add_report(create_test_report(1))
    @db.add_report(create_test_report(1))
    _reports = @db.all_reports(1, 10, 1)
    expect(_reports[:res_length]).to eq(_reports[:res].length)
    expect(_reports[:res_length]).to eq(2)
  end

  it 'save 2 report as guest, get all reports and check reports number' do
    @db.add_report(create_test_report)
    @db.add_report(create_test_report)
    @db.add_report(create_test_report)
    _reports = @db.all_reports(1, 10, nil)
    expect(_reports[:res_length]).to eq(_reports[:res].length)
    expect(_reports[:res_length]).to eq(3)
  end

  it 'destroy report' do
    @db.add_report(create_test_report(1))
    _id = @db.all_reports(1, 10, 1)[:res][0].view
    @db.find_report(_id)
    @db.destroy_report(_id, 1)
    expect{@db.find_report(_id)}.to raise_error(App::NoReportError)
  end
end