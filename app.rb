require 'sinatra'
require 'dotenv'
require 'bcrypt'
require 'sinatra/activerecord'
require './model/user'
require 'openssl'
require 'json'
require 'byebug'
require 'sinatra/flash'
require 'redcarpet'

Dotenv.load

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
        @partial = :user
        erb :base
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
