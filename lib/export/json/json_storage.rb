require_relative '../abstract_storage'
require './lib/configuration/configuration'

module JsonExport
  class JsonStorage < App::AbstractStorage
    FILE_FORMAT = '.json'

    def all_reports(page, per_page, user_id)
      _files_info = []
      Dir.foreach(App::Configuration.instance.json['base_dir']) do |filename|
        unless filename=='.' || filename=='..'
          _url, _time = filename.split('_')
          _time.slice!(FILE_FORMAT)
          _files_info << ResultList.new(_url, DateTime.parse(_time), filename)
        end
      end
      _files_info.sort! { |a, b| b.time <=> a.time }
      _files_info = _files_info[page * (per_page - 1), per_page]
      {res_length: _files_info.length, res: _files_info}
    end

    def add_report(info)
      File.open(App::Configuration.instance.json['base_dir'] + "#{domain_name(info.url)}_#{info.date.strftime('%d.%m.%Y %H:%M:%S')}" + FILE_FORMAT, 'w') { |f| f.write(info.to_json) }
    end

    def domain_name(url)
      _url_copy = url.clone
      _position = _url_copy.index('//')
      _url_copy[0, _position+2] = '' if _position
      _position = _url_copy.index('/')
      _url_copy = _url_copy[0, _position] if _position
      _url_copy
    end

    def find_report(file_name)
      File.open(App::Configuration.instance.json['base_dir'] + file_name, 'r') { |f| JSON.load(f.read) }
    end

    def password_auth(username, password)
      raise NotImplementedError;
    end

    def get_user_by_id(id)
      nil
    end

    def destroy_report(report_id, user_id)
      raise NotImplementedError;
    end
  end
end