require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative 'recipe'
# require_relative 'parser'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/new' do
  erb :recipe_form
end

# @cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))

get '/' do
  @cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  @recipes = @cookbook.all
  erb :index
end

post '/recipes' do
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time], false, params[:difficulty])
  @cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  @cookbook.add_recipe(recipe)
  redirect '/'
end

get '/destroy' do
  @cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  @recipes = @cookbook.all
  erb :get_index
end

post '/remove' do
  @cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  @cookbook.remove_recipe(params[:index].to_i - 1)
  redirect '/'
end
