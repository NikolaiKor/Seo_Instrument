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
      slim :index, locals: RequestWorker.new.get_reports_list
    end

    get '/report' do
      slim :report, locals: {res: RequestWorker.new.get_report(@params['file'])}
    end

    post '/link' do
      slim :report, locals: {res: RequestWorker.new.get_info(@params['url'])}
    end
  end
end
