

#class to handle the starting of a game of blackjack.
class Splash
    #initializer requires an instance of shoes
    def initialize(shoes)
        @shoes = shoes
    end

    #function called to begin the game of blackjack
    def start_game
        #present the splash image
        @splashImage = @shoes.image(    "blackjack_splash.png",
                                        left: 150,
                                        top:  300 )

        #present the start button and title
        @stack = @shoes.stack(margin: 50) do
            @prompt = @shoes.title( "Blackjack", stroke: "#FFF" )
            @author = @shoes.para(  "By: Thomas Tracy", stroke: "#FFF")
            @startButton = @shoes.button ("Start")

            #once the start button is clicked, remove the splash and start the game
            @startButton.click do

                #remove splash
                @stack.remove
                @splashImage.remove

                #create the game view
                newGame = GameView.new(@shoes)
                newGame.create_view

            end #end click
        end #end stack
    end #end start_game
end #end Splash
