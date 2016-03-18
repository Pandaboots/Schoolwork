#ratio for card display widths
$CARD_WIDTH = 100
#ratio for card display heights
$CARD_HEIGHT = 150
#color for text
$WHITE = "#FFF"




#class to gather up the cards and put them into a deck
class GameView
    def initialize(shoes)
        @shoes = shoes
        @controller = GameController.new
        @playerHand = Hand.new
        @dealerHand = Hand.new
    end

    def create_gameView
        self.create_playerSpace
    end

    #create the game view for the game to be played in
    def create_playerSpace

        #set up the gamescreen with the deck and the dealer and the player
        #outside stack holding everything
        @gameStack = @shoes.stack do
            #flow holding the horizontal space for the dealer
            @dealerFlow = @shoes.flow(height: 250) do
                #stack holding relevant information about the dealer
                @dealerInfo = @shoes.stack do
                    @shoes.para("Dealer ")
                    @dealerScore = @shoes.para("??")
                    @dealerWins = @shoes.para("Wins:")
                end# dealerInfo
            end# dealerFlow

            #Computer Player?

            #flow holding the horizontal space for the player
            @playerFLow = @shoes.flow(height: 250) do
                #stack holding relevant player information
                @playerInfo = @shoes.stack do
                    @shoes.para("Player ")
                    @playerScore = @shoes.para("??")
                    @playerWins = @shoes.para("Wins: ")
                end# playerInfo
                @cardflowPlayer = @shoes.flow do

                end
            end# playerflow
        end# gameStack

        #make room for the control buttons for the player to use to play the game
        @controlFlow = @shoes.flow do
            @hit = @shoes.button("Draw");
            @stay = @shoes.button("stay");
            @newGame = @shoes.button("New Game");
        end# controlFlow


        #handle the starting of a new game
        @newGame.click do


            @controller.shuffle_deck
            @controller.draw_card(@playerHand)
            @controller.draw_card(@playerHand)
            @cardflowPlayer.append do
                i = 0
                while(i < @playerHand.get_hand_size)

                    @playerCards.push( @shoes.image("Cards/#{@playerHand.get_hand_name(i)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT))
                    i += 1
                end
            end
        end


    end# create_playerSpace



end# GameView
