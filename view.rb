class View
  def display(cookbook)
    puts "-- Here are all your recipes --"
    puts ""
    cookbook.each_with_index do |recipe, index|
      completed = recipe.completed == "true" || recipe.completed == true ? "[x]" : "[ ]"
      puts "#{index + 1}. #{completed} #{recipe.name} (#{recipe.prep_time}) (#{recipe.difficulty})"
    end
  end

  def view_description(cookbook, index)
    puts ""
    puts "#{cookbook[index].name} - Preparation time: #{cookbook[index].prep_time} - Difficulty: #{cookbook[index].difficulty}"
    puts cookbook[index].description.split(/(\:)|\./).map { |s| "> #{s.strip}" }.join("\n").gsub(/\:/, "------")
    puts ""
  end

  def new_recipe
    puts "What is the recipe #{yield}?"
    print ">"
    return gets.chomp
  end

  def ask_user_for_index
    puts "Index of recipe to delete?"
    print ">"
    return gets.chomp.to_i - 1
  end

  def ask_user_for_index_to_view
    puts "Index of recipe to view?"
    print ">"
    return gets.chomp.to_i - 1
  end

  def ask_user_for_index_mark_as_done
    puts "Index of recipe to mark as done?"
    print ">"
    return gets.chomp.to_i - 1
  end

  def ask_user_for_ingredient
    puts "What ingredient would you like a recipe for?"
    print ">"
    return gets.chomp
  end

  def display_search_results(ingredient, results)
    puts "Looking for \"#{ingredient}\" on LetsCookFrench..."
    puts ""
    results.each_with_index do |result, index|
      puts "#{index + 1}. #{result}"
    end
  end

  def ask_user_for_index_to_import
    puts "Which recipe would you like to import? (enter index)"
    print ">"
    return gets.chomp.to_i - 1
  end

  def display_import(recipe)
    puts ""
    puts "Importing \"#{recipe}\"..."
  end

  def ask_user_for_difficulty
    puts "Select all the difficulty options to include in your search:"
    puts "1. Very easy"
    puts "2. Easy"
    puts "3. Moderate"
    puts "4. Difficult"
    puts "Or, press enter to use default search"
    print ">"
    return gets.chomp.gsub(/[^1234]/, "").chars.uniq.sort.map { |d| "&dif=#{d}" }.join
  end
end
