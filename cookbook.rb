require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_path)
    @csv_path = csv_path
    @cookbook = load_csv
  end

  def all
    @cookbook
  end

  def add_recipe(recipe)
    @cookbook << recipe
    add_to_csv(recipe)
  end

  def remove_recipe(index)
    @cookbook.delete_at(index)
    remove_from_csv(index)
  end

  def load_csv
    recipes = []
    CSV.foreach(@csv_path) do |recipe|
      recipes << Recipe.new(recipe[0], recipe[1], recipe[2], recipe[3], recipe[4])
    end
    return recipes
  end

  def add_to_csv(recipe)
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }

    CSV.open(@csv_path, 'a+', csv_options) do |csv|
      csv << [recipe.name.to_s, recipe.description.to_s, recipe.prep_time.to_s, recipe.completed.to_s, recipe.difficulty.to_s]
    end
  end

  def remove_from_csv(index)
    recipes = CSV.table(@csv_path)
    recipes.delete(index - 1)

    File.open(@csv_path, 'w') do |file|
      file.write(recipes.to_csv)
    end
  end

  def mark_as_done(index)
    @cookbook[index].mark_as_done
    posts = CSV.table(@csv_path, headers: false)
    posts[index][3] = "true"

    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(@csv_path, 'w', csv_options) do |csv|
      posts.each do |row|
        csv << row
      end
    end
  end
end
