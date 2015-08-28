require "sinatra/base"
require "tilt/erb"

unless Sinatra::Base.production?
  require "dotenv"
  Dotenv.load!
end

require "./core/cached_banking"

class App < Sinatra::Base
  enable :sessions

  get "/" do
    if params[:public_token]
      @user = CachedBanking.find_plaid_user(params[:public_token])
    end

    erb :index
  end

  helpers do
    def partial(name, **locals)
      erb :"_#{name}", locals: locals
    end

    def number_to_currency(number)
      number_string = "$%.2f" % number.abs
      number_string = "- #{number_string}" if number <= 0
      number_string
    end
  end
end
