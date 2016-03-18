require 'green_shoes'
require_relative 'View_application/View_Splash'
require_relative 'View_application/View_Gameview'
require_relative 'Controller/Controller'
require_relative 'Model/Model_createDeck'

Shoes.app title: "Blackjack!", width: 1024, height: 768 do
    background "#070"
    #newGame = Splash.new(self)
    #newGame.start_game
    newGame = GameView.new(self)
    newGame.create_gameView
end
