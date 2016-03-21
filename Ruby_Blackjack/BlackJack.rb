#####################################################
# =>Blackjack.RB
# => Created by: Thomas Tracy
# => This file is the entry point for the application
# => Created on: Feb 10, 2016
#####################################################

require 'green_shoes'
require_relative 'View_application/View_Splash'
require_relative 'View_application/View_Gameview'
require_relative 'Controller/Controller'
require_relative 'Model/Model_createDeck'

Shoes.app title: "Blackjack!", width: 1024, height: 768 do
    background "#070"
    newGame = GameView.new(self)
    newGame.create_gameView
end
