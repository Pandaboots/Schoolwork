#REQUIRED FILE
require_relative 'View_Splash'
require_relative 'View_Gameview'
require_relative 'Model_createDeck'
require_relative 'Controller'
require 'green_shoes'



#"Main" of the application. starts an istance of shoes to play the game in.
Shoes.app do
    #set the background to that felty green color
    background "#070"

    #start a new game with the splash screen
     newGame = Splash.new(self)
     newGame.start_game
end
