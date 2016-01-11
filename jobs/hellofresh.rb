require 'nokogiri'
require 'open-uri'

recipes_url = "https://www.hellofresh.co.uk/recipe/week/next/"

class HelloFresh
  def initialize(recipes_url)
    @page = Nokogiri::HTML(open(recipes_url))
  end

  def upcoming_recipes()
    recipes = []
    recipes_containers = @page.css("div.recipe-item")
    recipes_containers.each do |recipe_item|
      recipe = RecipeBuilder.BuildFrom(recipe_item)
      recipes.push(recipe)
    end
    recipes
  end
end

class RecipeBuilder
  def self.BuildFrom(recipe_item)
    {
      title: recipe_item.at_css("h3").text,
      subtitle: recipe_item.at_css("p.mbl").text,
      photo: recipe_item.at_xpath("div[2]/div[1]/div/img[@class='img-responsive mbl']")["src"],
      calories: recipe_item.at_xpath("div[4]/div[1]/div/table/tr[1]/td[2]").text,
      cookingtime: recipe_item.at_xpath("div[2]/div[2]/p[2]/span[3]").text
    }
  end
end

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '10m', :first_in => 0 do |job|
  hf = HelloFresh.new(recipes_url)
  recipes = hf.upcoming_recipes
  send_event('hellofresh', { :recipes => recipes })
end