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
      @title = nil
    end

    get '/' do
      @title = 'Seo Instrument'
      @slim_active_tab = 'home'
      slim :main_block, locals: reports_list
    end

    get '/reports/show' do
      _report = RequestWorker.new.get_report(@params['file'])
      @title = "#{_report.url} report in Seo Instrument"
      slim :report, locals: {res: _report}
    end

    post '/reports/destroy' do
      RequestWorker.new.destroy_report(@params[:id].to_i, current_user_id)
      redirect '/reports/my'
    end

    get '/info' do
      @title = 'Information about Seo Instrument'
      @slim_active_tab = 'info'
      slim :info
    end

    post '/reports/new' do
      slim :report, locals: {res: RequestWorker.new.get_info(@params['url'], current_user_id)}
    end

    get '/auth/login' do
      redirect '/reports/my' if env['warden'].authenticate?
      @title = 'Sign in Seo Instrument'
      @slim_active_tab = 'login'
      slim :login
    end

    post '/auth/login' do
      env['warden'].authenticate!
      if session[:return_to].nil?
        redirect '/reports/my'
      else
        redirect session[:return_to]
      end
    end

    post '/auth/logout' do
      env['warden'].logout
      redirect '/'
    end

    get '/reports/my' do
      @title = 'My reports in Seo Instrument'
      redirect '/auth/login' unless env['warden'].authenticated?
      @slim_active_tab = 'my_reports'
      slim :main_block, locals: reports_list(current_user_id)
    end
  end
end