require 'csv'
require_relative 'recipe'

class Cookbook
  # initialize(csv_file_path) which loads existing Recipe from the CSV
  attr_accessor :cookbook
  def initialize(csv_file_path)
    @recipes = []
    @filepath = csv_file_path
    csv_options = { col_sep: ',', quote_char: '"' }

    CSV.foreach(@filepath, csv_options) do |row|
      # push each row (recipe) into the cookbook
      @recipes.push(Recipe.new(row[0], row[1], row[2], row[3], row[4]))
    end
  end

  # all which returns all the recipes
  def all
    @recipes
  end

  # add_recipe(recipe) which adds a new recipe to the cookbook
  def add_recipe(recipe)
    @recipes.push(recipe)
    save
  end

  # remove_recipe(recipe_index) which removes a recipe from the cookbook.
  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    save
  end

  def mark_done(index)
    @recipes[index].done = true
    save
  end

  def save
    CSV.open(@filepath, 'wb') do |csv|
      @recipes.each do |r|
        csv << [r.name, r.description, r.prep_time, r.done, r.difficulty]
      end
    end
  end
end

# cookbook = Cookbook.new('recipes.csv')
# cookbook.add_recipe("Chocolate", "Cocoa", "Do something with the cocoa")
# p cookbook.all
# cookbook.remove_recipe(1)
# p cookbook.all
