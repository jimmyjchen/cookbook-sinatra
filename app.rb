require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
require_relative 'cookbook'
require_relative 'recipe'
require_relative 'search_recipes'

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

post '/recipes' do
  @csv_file = File.join(__dir__, 'recipes.csv')
  @cookbook = Cookbook.new(@csv_file)
  recipe = Recipe.new(params[:name], params[:description], params[:prep_time], false, params[:difficulty])
  @cookbook.add_recipe(recipe)
  @cookbook_array = @cookbook.all
  erb :index
end


