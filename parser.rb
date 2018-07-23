require 'nokogiri'
require 'open-uri'

class Parser
  def initialize(query)
    url = URI.parse("http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{query}")
    html_content = url.read
    @doc = Nokogiri::HTML(html_content)
  end

  def parse
    recipe_titles = []
    @doc.search('.m_titre_resultat').each { |name| recipe_titles << name }
    recipe_names = recipe_titles.first(5).map { |title| title.text.strip }
    return recipe_names.first(5)
  end

  def select_recipe(index)
    recipe_names = parse
    return recipe_names[index]
  end

  def parse_recipe_link
    links = @doc.search('.m_titre_resultat').xpath('//div[@class="m_titre_resultat"]//a/@href').map do |inner|
      inner.value
    end
    return links
  end

  def get_inner_doc(index)
    links = parse_recipe_link
    inner = links[index]
    url = URI.parse("http://www.letscookfrench.com#{inner}")
    html_content = url.read
    doc = Nokogiri::HTML(html_content)
    return doc
  end

  def scrape_description(index)
    doc = get_inner_doc(index)
    description = ""
    description += doc.search('.m_content_recette_ingredients.m_avec_substitution span').text
    description += doc.xpath('//div[@class="m_content_recette_ingredients m_avec_substitution"]//div[@data-type="gr"]').text.split("-").reject{|e| e.empty?}.map{|item| '-'+item}.join("\n")
    description = "\n"
    description += doc.search('.m_content_recette_todo').text.strip.squeeze(" ")
    return description
  end

  def scrape_prep_time(index)
    doc = get_inner_doc(index)
    prep_time = doc.search('.preptime').text.strip + " min"
    return prep_time
  end

  def scrape_difficulty(index)
    doc = get_inner_doc(index)
    difficulty = doc.search('.m_content_recette_breadcrumb').text
    difficulty = difficulty.strip.split("-").map { |element| element.strip }.reject { |element| element.empty? }
    return difficulty[1]
  end
end
