require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require_relative 'cookbook'
require_relative 'recipe'
require_relative 'search_recipes'

# Create global variables for csv_file and cookbook to have DRY code

set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  @csv_file = File.join(__dir__, 'recipes.csv')
  @cookbook = Cookbook.new(@csv_file)
  @cookbook_array = @cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/import' do
  @recipes = SearchRecipes.call(params[:ingredient])
  erb :import
end

post '/recipes' do
  @csv_file = File.join(__dir__, 'recipes.csv')
  @cookbook = Cookbook.new(@csv_file)
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time] + " min", false, params[:difficulty])
  @cookbook.add_recipe(recipe)
  @cookbook_array = @cookbook.all
  redirect to('/')
end

post '/delete' do # this can just be a get by routing the delete request to delete/index
  @csv_file = File.join(__dir__, 'recipes.csv')
  @cookbook = Cookbook.new(@csv_file)
  @cookbook.remove_recipe(params[:index].to_i)
  @cookbook_array = @cookbook.all
  redirect to('/')
end
