class Recipe
  attr_reader :name, :description, :prep_time, :completed, :difficulty

  def initialize(name, description, prep_time, completed, difficulty = "")
    @name = name
    @description = description
    @prep_time = prep_time
    @completed = completed
    @difficulty = difficulty
  end

  def mark_as_done
    @completed = true
  end
end
