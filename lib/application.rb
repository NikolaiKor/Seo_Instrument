# encoding: utf-8
require 'sinatra'
require_relative 'controler/request_worker'
require_relative 'controler/files_manager'
require 'json'

module App
  class Application < Sinatra::Application
    set :public_folder, './public'
    set :views, './views'
    set :slim, default_encoding:'utf-8'

    get '/' do
      _result_list = FilesManager.new.dir_contents
      Slim::Template.new('./views/index.slim', encoding: 'utf-8').render([_result_list.length,_result_list])
      #slim :index
    end

    get '/report' do
      Slim::Template.new('./views/report.slim', encoding: 'utf-8').render(JSON.load(FilesManager.new.get_json(@params['file'])))
    end

    post '/link' do
      _info = RequestWorker.new.get_info(@params['url'])

      #problem: default encoding is utf-8, but chrome open file with Windows-1251
      #I also try to set default encoding as utf-8, but chrome  open file with Windows-1251
      #how fix it?

      #can I set some params and write only report.slim without views folder path?
      FilesManager.new.save_file(_info,"#{_info.domain}_#{_info.date}")
      Slim::Template.new('./views/report.slim', encoding: 'utf-8').render(_info)
    end
  end
end
