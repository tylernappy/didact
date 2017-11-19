require 'sinatra'
require 'dotenv'
require 'bcrypt'
require 'sinatra/activerecord'
require './model/user'
require 'openssl'
require 'json'
require 'byebug'
require 'sinatra/flash'

Dotenv.load

class Didact < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do
    erb :index
  end

end
