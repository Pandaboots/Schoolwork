#Global variable constants

#ratio for card display widths
$CARD_WIDTH = "14%"
#ratio for card display heights
$CARD_HEIGHT = "21%"

#class to gather up the cards and put them into a deck
class GameView
    def initialize(shoes)
        @shoes = shoes
        @controller = GameController.new
    end

    def create_gameView
        self.create_namePrompt
    end

    #create the game view for the game to be played in
    def create_namePrompt

        #choosing a name stack
        @nameStack = @shoes.stack(margin: "30") do
            @namePrompt = @shoes.para("Please enter your name: ", stroke: "#FFF")
            @shoes.flow do
                @inputLine = @shoes.edit_line
                @OKButton = @shoes.button("OK")
            end# flow
        end # @nameStack

        #remove the name entry form returning the name into playerName
        @OKButton.click do
            @playerName = @inputLine.text
            @nameStack.remove
            self.create_playerSpace
        end# @OKButton.click
    end# game_view


    def create_playerSpace

        #set up the gamescreen with the deck and the dealer and the player
        #outside stack holding everything
        @gameStack = @shoes.stack(margin: "50") do
            #flow holding the horizontal space for the dealer
            @dealerFlow = @shoes.flow do
                #stack holding relevant information about the dealer
                @dealerInfo = @shoes.stack do
                    @shoes.title("Dealer: ", stroke: "#FFF" )
                    @dealerScore = @shoes.title("??", stroke: "#FFF")
                    @dealerWins = @shoes.title("Wins:", stroke: "#FFF")
                end# dealerInfo
            end# dealerFlow


            #flow holding the horizontal space for the player
            @playerFLow = @shoes.flow(margin_top: "60") do
                #stack holding relevant player information
                @playerInfo = @shoes.stack do
                    @shoes.title("#{@playerName}: ", stroke: "#FFF")
                    @playerScore = @shoes.title("??", stroke: "#FFF")
                    @playerWins = @shoes.title("Wins: ", stroke: "#FFF")
                end# playerInfo
            end# playerflow
        end# gameStack

        #make room for the control buttons for the player to use to play the game
        @controlFlow = @shoes.flow(margin: "60") do
            @hit = @shoes.button("Draw", margin: "10");
            @stay = @shoes.button("stay", margin: "10");
            @newGame = @shoes.button("New Game", margin: "10");
        end# controlFlow

    end# create_playerSpace

end# GameView
