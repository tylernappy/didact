require 'sinatra'
require 'dotenv'
require 'bcrypt'
require 'sinatra/activerecord'
require './model/user'
require './model/Integration'
require './model/task'
require './model/comment'
require 'openssl'
require 'json'
require 'byebug'
require 'sinatra/flash'
require 'redcarpet'
require 'time'

Dotenv.load

@@redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, hard_wrap: true, prettify: true, fenced_code_blocks: true)
# @@redcarpet = Redcarpet::Render::HTML.new(hard_wrap: true, prettify: true)

class Didact < Sinatra::Base
    enable :sessions
    register Sinatra::Flash

    helpers do
        def is_user?
            @user != nil
        end
    end

    before do
        @user = User.find(session[:user_id]) unless session[:user_id].nil?
    end

    get '/' do
        @partial = :index
        erb :base
    end

    get '/user/:user_id' do
        @integrations = @user.integrations

        @partial = :user
        erb :base
    end

    get '/new_integration' do
        @partial = :new_integration
        erb :base
    end

    post '/integration' do
        @integration  = @user.integrations.create!(params.except(:captures))
        redirect "/user/#{@user.id}/integration/#{@integration.id}"
    end

    get '/user/:user_id/integration/:integration_id' do
        @integration = Integration.find(params[:integration_id])
        @tasks = @integration.tasks.order(:due_date)

        @partial = :integration
        erb :base
    end

    get '/user/:user_id/integration/:integration_id/new_task' do
        @integration_id = params[:integration_id]

        @partial = :new_task
        erb :base
    end

    post '/task' do
        integration = @user.integrations.find_by_id(params[:integration_id].to_i)
        task = integration.tasks.create(params.except(:captures))
        redirect "/user/#{@user.id}/integration/#{integration.id}"
    end

    ## Login, Signup, Logout
    get '/signup' do
        @partial = :signup
        erb :base
    end

    post '/signup' do
        @user = User.create!(params.except(:captures))
        session[:user_id] = @user.id
        redirect "/user/#{@user.id}"
    end

    get '/login' do
        @partial = :login
        erb :base
    end

    post '/login' do
        @user = User.find_by_email(params[:email])
        if @user.nil?
            flash[:error] = "In correct email or password"
            redirect '/login'
        elsif @user.password == params[:password]
            session[:user_id] = @user.id
            redirect "/user/#{@user.id}"
        else
            flash[:error] = "Something went wrong"
            redirect '/login'
        end
    end


    get '/logout' do
        session[:user_id] = nil
        redirect '/'
    end

end
