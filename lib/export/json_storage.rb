require_relative 'abstract_storage'
require_relative '../model/result_list'

class JsonStorage < AbstractStorage
  TYPE = 'json'
  BASE_DIR = './public/reports/'
  FILE_FORMAT = '.json'

  def all_reports
    _files_info = []
    Dir.foreach(BASE_DIR) do |filename|
      unless filename=='.' || filename=='..'
        _url, _time = filename.split('_')
        _time.delete!(FILE_FORMAT)
        _files_info << ResultList.new(_url, _time, filename)
      end
    end
    {res_length:_files_info.length, res:_files_info}
  end

  def add_report(info)
    File.open(BASE_DIR + "#{info.domain}_#{info.date}" + FILE_FORMAT, 'w') { |f| f.write(info.to_json) }
  end

  def find_report(file_name)
    File.open(BASE_DIR + file_name, 'r') { |f| JSON.load(f.read) }
  end
end