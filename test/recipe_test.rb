require 'minitest/autorun'
require 'minitest/pride'
require './lib/ingredient'
require './lib/recipe'
require 'pry'

class RecipeTest < MiniTest::Test

  def setup
    @ingredient1 = Ingredient.new({name: "Cheese", unit: "oz", calories: 50})
    @ingredient2 = Ingredient.new({name: "Macaroni", unit: "oz", calories: 200})
    @recipe1 = Recipe.new("Mac and Cheese")
  end

  def test_the_recipe

    assert_equal "Mac and Cheese", @recipe1.name
    assert_equal ({}), @recipe1.ingredients_required
  end

  def test_ingredients
    @recipe1.add_ingredient(@ingredient1, 2)
    @recipe1.add_ingredient(@ingredient1, 4)
    @recipe1.add_ingredient(@ingredient2, 8)
    expected = {@ingredient1 => 6, @ingredient2 => 8}
    assert_equal expected, @recipe1.ingredients_required

    assert_equal [@ingredient1, @ingredient2], @recipe1.ingredients
  end

end
