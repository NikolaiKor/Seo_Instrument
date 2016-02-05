require 'sinatra'
require_relative 'controler/request_worker'
require_relative 'controler/files_manager'
require 'json'
require_relative 'helpers'

module App
  class Application < Sinatra::Application
    enable :sessions
    set :public_folder, './public'
    set :views, './views'
    set :slim, :layout => :main_layout

    before do
      @slim_active_tab = nil
    end

    get '/' do
      @slim_active_tab = 'home'
      _page = @params[:page].to_i
      _page = 1 if _page <= 0
      _per_page = @params[:per_page].to_i
      _per_page = 3 if _per_page <= 0
      slim :main_block, locals: RequestWorker.new.get_reports_list(_page, _per_page)
    end

    get '/report' do
      slim :report, locals: {res: RequestWorker.new.get_report(@params['file'])}
    end

    get '/info' do
      @slim_active_tab = 'info'
      slim :info
    end

    post '/link' do
      slim :report, locals: {res: RequestWorker.new.get_info(@params['url'], current_user_id)}
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
      if session[:return_to].nil?
        redirect '/my_reports'
      else
        redirect session[:return_to]
      end
    end

    post '/auth/logout' do
      env['warden'].raw_session.inspect
      env['warden'].logout
      redirect '/'
    end

    get '/my_reports' do
      print current_user_id
      @slim_active_tab = 'my_reports'
      _page = @params[:page].to_i
      _page = 1 if _page <= 0
      _per_page = @params[:per_page].to_i
      _per_page = 3 if _per_page <= 0
      slim :main_block, locals: RequestWorker.new.get_reports_list(_page, _per_page, current_user_id)
    end
  end
end