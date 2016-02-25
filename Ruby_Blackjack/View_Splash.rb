

#class to handle the starting of a game of blackjack.
class Splash
    #initializer requires an instance of shoes
    def initialize(shoes)
        @shoes = shoes
    end

    #function called to begin the game of blackjack
    def start_game
        #present the start button and title and image
        @stack = @shoes.stack(margin_left:"50%", left: "-25%") do
            @prompt = @shoes.title( "Blackjack", stroke: "#FFF", align: "center" )
            @author = @shoes.para(  "By: Thomas Tracy", stroke: "#FFF", align: "center")
            @toBegin = @shoes.title( "Click the cards to begin!", stroke: "#FFF", align: "center")
            @splashImage = @shoes.image(    "blackjack_splash.png", top: 250, left: 100)

            #once the start button is clicked, remove the splash and start the game
            @splashImage.click do

                #remove splash
                @stack.remove
                @splashImage.remove

                #create the game view
                newGame = GameView.new(@shoes)
                newGame.create_gameView

            end #end click
        end #end stack
    end #end start_game
end #end Splash
