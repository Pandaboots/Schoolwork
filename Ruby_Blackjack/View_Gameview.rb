#Global variable constants



#class to gather up the cards and put them into a deck
class GameView
    def initialize(shoes)
        @shoes = shoes
    #    @controller = GameController.new
    end

    def create_gameView
        self.create_namePrompt
        self.create_playerSpace
    end

    #create the game view for the game to be played in
    def create_namePrompt

        #choosing a name stack
            @namePrompt = @shoes.para("Please enter your name: ")
            @inputLine = @shoes.edit_line.move(0,50)
            @OKButton = @shoes.button("OK").move(0,100)

        #remove the name entry form returning the name into playerName
        @OKButton.click do
            @playerName = @inputLine.text
            @nameStack.hide
            self.create_playerSpace
        end# @OKButton.click
    end# game_view


    def create_playerSpace

        #set up the gamescreen with the deck and the dealer and the player
        #outside stack holding everything
        @gameStack = @shoes.stack do
            #flow holding the horizontal space for the dealer
            @dealerFlow = @shoes.flow do
                #stack holding relevant information about the dealer
                @dealerInfo = @shoes.stack do
                    @shoes.para("Dealer: ")
                    @dealerScore = @shoes.para("??")
                    @dealerWins = @shoes.para("Wins:")
                end# dealerInfo
            end# dealerFlow

            #flow holding the horizontal space for computer player cards
            @compFlow = @shoes.flow do
                #stack holding relevant information about the dealer
                @compInfo = @shoes.stack do
                    @shoes.para("Computer Player: ")
                    @compScore = @shoes.para("??")
                    @compWins = @shoes.para("Wins:")
                end# compInfo
            end# compFlow


            #flow holding the horizontal space for the player
            @playerFLow = @shoes.flow do
                #stack holding relevant player information
                @playerInfo = @shoes.stack do
                    @shoes.para(": ")
                    @playerScore = @shoes.para("??")
                    @playerWins = @shoes.para("Wins: ")
                end# playerInfo
            end# playerflow
        end# gameStack

        #make room for the control buttons for the player to use to play the game
        @controlFlow = @shoes.flow do
            @hit = @shoes.button("Draw");
            @stay = @shoes.button("stay");
            @newGame = @shoes.button("New Game");
        end# controlFlow

    end# create_playerSpace

end# GameView
