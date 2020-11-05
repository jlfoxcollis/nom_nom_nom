class CookBook
  attr_reader :recipes

  def initialize
    @recipes = []
    date
  end

  def date
    Time.now
  end

  def add_recipe(recipe)
    @recipes << recipe
  end

  def ingredients
    names = []
    @recipes.each do |recipe|
      recipe.ingredients.each do |ingredient|
        names << ingredient.name
      end
    end
    names.uniq
  end

  def highest_calories_meal
    @recipes.max_by do |recipe|
      recipe.total_calories
    end
  end

  def summary
    super_summary = []
    @recipes.each do |recipe|
      super_summary << {
      :name => recipe.name,
      :details => {
      :ingredients =>
      recipe.ingredients_required.map do |ingredient, quantity|
        {:ingredient => ingredient.name, :amount => "#{quantity} #{ingredient.unit}"}
      end,
      :total_calories => recipe.total_calories}
      }
    end
    super_summary
  end

end
