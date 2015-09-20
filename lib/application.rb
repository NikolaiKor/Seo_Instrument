# encoding: utf-8
require 'sinatra'
require_relative 'controler/request_worker'
require_relative 'controler/files_manager'
module App
  class Application < Sinatra::Application
    set :public_folder, './public'
    set :views, './views'
    set :slim, default_encoding:'utf-8'

    get '/' do
      _file_manager = FilesManager.new
      _result_list = _file_manager.dir_contents
      Slim::Template.new('./views/index.slim', encoding: 'utf-8').render([_result_list.length,_result_list])
      #slim :index
    end

    get '/reports' do
      slim :report
    end

    post '/link' do
      _request_worker = RequestWorker.new
      _info = _request_worker.get_info(@params['url'])

      #problem: default encoding is utf-8, but chrome open file with Windows-1251
      #I also try to set default encoding as utf-8, but chrome  open file with Windows-1251
      #how fix it?

      #can I set some params and write only report.slim without views folder path?
      _file_info = Slim::Template.new('./views/report.slim', encoding: 'utf-8').render(_info)
      _files_manager = FilesManager.new
      _files_manager.save_file(_file_info,"#{_info.domain}_#{_info.date}")
      _file_info
    end
  end
end
