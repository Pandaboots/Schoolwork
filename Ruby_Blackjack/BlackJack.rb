require 'green_shoes'
require_relative 'View_Splash'
require_relative 'View_Gameview'

Shoes.app width: 1024, height: 768 do
    background "#070"
    #newGame = Splash.new(self)
    #newGame.start_game
    newGame = Splash.new(self)
    newGame.start_game
end
