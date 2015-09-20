require_relative '../model/result_list'
class FilesManager
  BASE_DIR = './public/reports/'
  BASE_DIR_OUTSIDE = '/reports/'

  def save_file(file_info, file_save_name) #raise NoMethodError if choose nothing
    File.open(BASE_DIR + file_save_name + '.html', 'w') do |f|
      f.write(file_info)
    end
  end

  def dir_contents
    _files_info = []
    Dir.foreach(BASE_DIR) do |filename|
      unless filename=='.' || filename=='..'
      _url, _time = filename.split('_')
      _time.delete!('.html')
      _files_info << ResultList.new(_url, _time, BASE_DIR_OUTSIDE + filename)
      end
    end
    _files_info
  end
end