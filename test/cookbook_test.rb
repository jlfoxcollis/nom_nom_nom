require 'minitest/autorun'
require 'minitest/pride'
require './lib/ingredient'
require './lib/recipe'
require './lib/cookbook'
require './lib/pantry'
require 'mocha/minitest'
require 'pry'

class RecipeTest < MiniTest::Test

  def setup
    @pantry = Pantry.new
    @cookbook = CookBook.new
    @ingredient1 = Ingredient.new({name: "Cheese", unit: "C", calories: 100})
    @ingredient2 = Ingredient.new({name: "Macaroni", unit: "oz", calories: 30})
    @ingredient4 = Ingredient.new({name: "Bun", unit: "g", calories: 1})
    @ingredient3 = Ingredient.new({name: "Ground Beef", unit: "oz", calories: 100})
    @recipe1 = Recipe.new("Mac and Cheese")
    @recipe2 = Recipe.new("Burger")
    @cookbook.stubs(:date => "04-22-2020")
  end

  def test_cook_book_recipes
    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)

    assert_equal [@recipe1, @recipe2], @cookbook.recipes
  end

  def test_the_calories_in_recipe
    @recipe1.add_ingredient(@ingredient1, 2)
    @recipe1.add_ingredient(@ingredient2, 8)
    @recipe2.add_ingredient(@ingredient1, 2)
    @recipe2.add_ingredient(@ingredient3, 4)
    @recipe2.add_ingredient(@ingredient4, 1)

    assert_equal 440, @recipe1.total_calories
    assert_equal 601, @recipe2.total_calories

    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)
    assert_equal ["Cheese", "Macaroni", "Ground Beef", "Bun"], @cookbook.ingredients
    assert_equal @recipe2, @cookbook.highest_calories_meal

    @pantry.restock(@ingredient1, 5)
    @pantry.restock(@ingredient1, 10)

    assert_equal false, @pantry.enough_ingredients_for?(@recipe1)
    @pantry.restock(@ingredient2, 7)

    assert_equal false, @pantry.enough_ingredients_for?(@recipe1)
    @pantry.restock(@ingredient2, 1)
    assert_equal 8, @pantry.stock_check(@ingredient2)
    assert_equal 15, @pantry.stock_check(@ingredient1)

    assert_equal true, @pantry.enough_ingredients_for?(@recipe1)
  end

  def test_date_and_summary

    assert_equal "04-22-2020", @cookbook.date

    @recipe1.add_ingredient(@ingredient2, 8)
    @recipe1.add_ingredient(@ingredient1, 2)
    @recipe2.add_ingredient(@ingredient3, 4)
    @recipe2.add_ingredient(@ingredient4, 100)
    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)
    expected =  [{:name=>"Mac and Cheese", :details=>{:ingredients=>[{:ingredient=>"Macaroni", :amount=>"8 oz"},
                {:ingredient=>"Cheese", :amount=>"2 C"}], :total_calories=>440}}, {:name=>"Burger", :details=>{:ingredients=>[{:ingredient=>"Ground Beef", :amount=>"4 oz"}, {:ingredient=>"Bun", :amount=>"100 g"}], :total_calories=>500}}]
    assert_equal expected, @cookbook.summary
  end
end
