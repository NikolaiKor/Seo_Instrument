# encoding: utf-8
require 'sinatra'
require_relative 'controler/request_worker'
require_relative 'controler/files_manager'
require 'json'
# require_relative 'export/data_mapper/data_mapper_storage'

module App
  class Application < Sinatra::Application
    enable :sessions
    set :public_folder, './public'
    set :views, './views'
    set :slim, default_encoding:'utf-8'
    set :slim, :layout=> :main_layout

    before do
      @slim_classes = Hash.new
      @slim_classes[:home_class] = ''
      @slim_classes[:login_class] = ''
      @slim_classes[:contact_class] = ''
    end

    get '/' do
      @slim_classes[:home_class] = 'active'
      slim :index, locals: RequestWorker.new.get_reports_list
    end

    get '/report' do
      slim :report, locals: {res: RequestWorker.new.get_report(@params['file'])}
    end

    get '/info' do
      slim :info
    end

    post '/link' do
      slim :report, locals: {res: RequestWorker.new.get_info(@params['url'])}
    end

    get '/auth/login' do
      @slim_classes[:login_class] = 'active'
      slim :login
    end

    # get '/migrate' do
    #   DataMapper.auto_migrate!
    #   "successfull!"
    # end

    post '/auth/unauthenticated' do
      session[:return_to] = env['warden.options'][:attempted_path]
      puts env['warden.options'][:attempted_path]
      redirect '/auth/login'
    end

    post '/auth/login' do
      env['warden'].authenticate!

      #_a = env['warden'].message

      if session[:return_to].nil?
        redirect '/'
      else
        redirect session[:return_to]
      end
    end

    post '/auth/logout' do
      env['warden'].raw_session.inspect
      env['warden'].logout
      redirect '/'
    end

  end
end
