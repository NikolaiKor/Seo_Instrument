require 'sinatra'
require_relative 'controler/request_worker'
require_relative 'controler/files_manager'
require 'json'

module App
  class Application < Sinatra::Application
    enable :sessions
    set :public_folder, './public'
    set :views, './views'
    set :slim, :layout=> :main_layout

    before do
      @slim_active_tab = nil
    end

    get '/' do
      @slim_active_tab = 'home'
      slim :index, locals: RequestWorker.new.get_reports_list(true)
    end

    get '/report' do
      slim :report, locals: {res: RequestWorker.new.get_report(@params['file'])}
    end

    get '/info' do
      @slim_active_tab = 'info'
      slim :info
    end

    post '/link' do
      slim :report, locals: {res: RequestWorker.new.get_info(@params['url'])}
    end

    get '/auth/login' do
      @slim_active_tab = 'login'
      slim :login
    end

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
