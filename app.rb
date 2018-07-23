require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/new' do # <- Router part
  # [...]  #
  # [...]  # <- Controller part
  # [...]  #
  #
  erb :recipe_form
end

get '/' do
  @recipes = [ 'replace', 'with', 'recipe', 'objects' ]
  erb :index
end

post '/recipes' do
  params.to_s # access parameters and create a new recipe object
  redirect '/'
end

# get '/team/:username' do
#   puts params[:username]
#   "The username is #{params[:username]}"
# end
