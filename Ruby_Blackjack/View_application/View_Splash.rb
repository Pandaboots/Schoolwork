#
#UNUSED
#

#class to handle the starting of a game of blackjack.
class Splash
    #initializer requires an instance of shoes
    def initialize(shoes)
        @shoes = shoes
    end

    #function called to begin the game of blackjack
    def start_game
        #present the start button and title and image
        @stack = @shoes.stack left: 200 do
            @prompt = @shoes.title( "Blackjack",
                                    stroke: $WHITE,
                                    align: "center")
            @author = @shoes.para(  "By: Thomas Tracy",
                                    stroke: $WHITE,
                                    align: "center")
            @toBegin = @shoes.title(    "Click the cards to begin!",
                                        stroke: $WHITE,
                                        align: "center")
            @splashImage = @shoes.image("View_application/blackjack_splash.png").move( 350, 250)

            #once the start button is clicked, remove the splash and start the game
            @splashImage.click do
                #remove splash
                @stack.clear
                @splashImage.clear
                #create the game view
                newGame = GameView.new(@shoes)
                newGame.create_gameView
            end #end click
        end #end stack
    end #end start_game
end #end Splash
