class Recipe
  attr_accessor :name, :description, :prep_time, :done, :difficulty
  def initialize(name, description, prep_time, done = false, difficulty = nil)
    @name = name
    @description = description
    @prep_time = prep_time
    @done = done
    @difficulty = difficulty
  end
end
