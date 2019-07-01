require 'open-uri'
require 'nokogiri'
require_relative 'recipe'

class SearchRecipes
  def self.call(ingredient)
    # url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?s=#{ingredient}"
    recipe_list = []
    url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?s=#{ingredient}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('.m_contenu_resultat').each do |e|
      recipe = Recipe.new("", "", "", false, "")
      recipe.name = e.search('.m_titre_resultat a').text
      recipe.description = e.search('.m_texte_resultat').text.lstrip
      recipe.prep_time = e.search('.m_detail_time').text.scan(/\d+..../).slice(0)
      recipe.difficulty = e.search('.m_detail_recette').text.scan(/(Very easy|Easy|Moderate|Difficult)/).join("/")
      recipe_list << recipe
    end

    return recipe_list.take(5)
  end
end
