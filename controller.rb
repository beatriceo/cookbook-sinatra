require_relative 'view'
require_relative 'recipe'
require_relative 'parser'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    @view.display(@cookbook.all)
  end

  def view_description
    list
    index = @view.ask_user_for_index_to_view
    @view.view_description(@cookbook.all, index)
  end

  def create
    name = @view.new_recipe { "name" }
    description = @view.new_recipe { "description" }
    prep_time = @view.new_recipe { "prep time" }
    difficulty = @view.new_recipe { "difficulty level" }
    @cookbook.add_recipe(Recipe.new(name, description, prep_time, false, difficulty))
  end

  def destroy
    list
    index = @view.ask_user_for_index
    @cookbook.remove_recipe(index)
  end

  def import
    ingredient = @view.ask_user_for_ingredient
    diff_url = @view.ask_user_for_difficulty
    parser = Parser.new(ingredient + diff_url)
    @view.display_search_results(ingredient, parser.parse)
    index = @view.ask_user_for_index_to_import
    name = parser.select_recipe(index)
    @view.display_import(name)
    parser.parse_recipe_link
    description = parser.scrape_description(index)
    prep_time = parser.scrape_prep_time(index)
    difficulty = parser.scrape_difficulty(index)
    @cookbook.add_recipe(Recipe.new(name, description, prep_time, false, difficulty))
  end

  def mark_as_done
    list
    index = @view.ask_user_for_index_mark_as_done
    @cookbook.mark_as_done(index)
  end
end
