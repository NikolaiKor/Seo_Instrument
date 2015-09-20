require_relative '../model/result_list'
class FilesManager
  BASE_DIR = './public/reports/'
  FILE_FORMAT = '.json'

  def save_file(file_info, file_save_name)
    File.open(BASE_DIR + file_save_name + FILE_FORMAT, 'w') { |f| f.write(file_info.to_json) }
  end

  def dir_contents
    _files_info = []
    Dir.foreach(BASE_DIR) do |filename|
      unless filename=='.' || filename=='..'
        _url, _time = filename.split('_')
        _time.delete!(FILE_FORMAT)
        _files_info << ResultList.new(_url, _time, filename)
      end
    end
    _files_info
  end

  def get_json(file_name)
    File.open(BASE_DIR + file_name, 'r') { |f| f.read }
  end
end