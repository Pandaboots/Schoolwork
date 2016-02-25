#REQUIRED FILE
require 'View_Splash'
require 'View_Gameview'
require 'Model_createDeck'
require 'Controller.rb'



#"Main" of the application. starts an istance of shoes to play the game in.
Shoes.app(title: "Blackjack", width: 1024, height: 768) do
    #set the background to that felty green color
    background "#070"

    #start a new game with the splash screen
     newGame = Splash.new(self)
     newGame.start_game
end
