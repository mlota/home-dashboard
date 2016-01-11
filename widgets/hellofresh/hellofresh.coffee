class Dashing.Hellofresh extends Dashing.Widget

  ready: ->
    @currentIndex = 0
    @recipeElem = $(@node).find('.recipe-container')
    @nextRecipe()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextRecipe, 8000)

  nextRecipe: =>
    recipes = @get('recipes')
    if recipes
      @recipeElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % recipes.length
        @set 'current_recipe', recipes[@currentIndex]
        @recipeElem.fadeIn()