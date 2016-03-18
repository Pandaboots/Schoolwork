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

        @playerWinsCount = 0
        @dealerWinsCount = 0
        #set up the gamescreen with the deck and the dealer and the player
        #outside stack holding everything
        @gameStack = @shoes.stack do
            #flow holding the horizontal space for the dealer
            @dealerFlow = @shoes.flow(height: 250) do
                #stack holding relevant information about the dealer
                @dealerInfo = @shoes.stack do
                  @dealerName =  @shoes.para("Dealer ")
                    @dealerScore = @shoes.para("??")
                    @dealerWins = @shoes.para("Wins: #{@dealerWinsCount}")
                end# dealerInfo
                @cardflowDealer = @shoes.flow do
                  @cardArDealer = Array.new
                end
            end# dealerFlow

            #Computer Player?

            #flow holding the horizontal space for the player
            @playerFLow = @shoes.flow(height: 250) do
                #stack holding relevant player information
                @playerInfo = @shoes.stack do
                  @name =  @shoes.para "Player "
                    @playerScore = @shoes.para "??"
                    @playerWins = @shoes.para "Wins: #{@playerWinsCount}"
                end# playerInfo
                @cardflowPlayer = @shoes.flow do
                  @cardArPlayer = Array.new
                end
            end# playerflow
        end# gameStack

        #make room for the control buttons for the player to use to play the game
        @controlFlow = @shoes.flow do
            @newGame = @shoes.button("New Game")
            @hit = @shoes.button("Draw")
            @stay = @shoes.button("stay")
            @hit.hide
            @stay.hide
        end# controlFlow

        #and the winner banner
        @winnerFlow = @shoes.flow do

        end


        #handle the starting of a new game
        @newGame.click do
          new_game_start
       end

       #handle when the player hits
       @hit.click do
         @controller.draw_card(@playerHand)
         @cardflowPlayer.append do
           @cardArPlayer << @shoes.image("Cards/#{@playerHand.get_hand_name(-1)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
         end

         @playerScore.clear
         @playerInfo.after(@name) do
           @playerScore = @shoes.para("#{@playerHand.get_hand_score}")
         end

         if(@playerHand.get_hand_score > 21)
          @winnerFlow.append  do
             @shoes.title "You Bust!", align: "center", stroke: "#FFF"
           end
           @dealerWinsCount += 1
           @hit.hide
           @stay.hide
         end

       end

       #handle when the player decides to stay
       @stay.click do
         @hit.hide
         @stay.hide
         dealerScore = @dealerHand.handle_dealer(@controller)
         i = 0
         @cardArDealer.each { |x| x.clear  }
         while( i < @dealerHand.get_hand_size)
           @cardflowDealer.append do
           @cardArDealer << @shoes.image("Cards/#{@dealerHand.get_hand_name(i)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
           end
           i += 1
        end

        @dealerScore.clear
        @dealerInfo.after(@dealerName) do
          @dealerScore = @shoes.para("#{@dealerHand.get_hand_score}")
        end

         if(dealerScore > @playerHand.get_hand_score || dealerScore == 1)
           @winnerFlow.append do
             @shoes.title "You Lose!", align: "center", stroke: "#FFF"
           end
           @dealerWinsCount += 1
         else
          @winnerFlow.append do
             @shoes.title "You Win!", align: "center", stroke: "#FFF"
           end
           @playerWinsCount += 1
         end
       end

    end# create_playerSpace

    #clearing the board of old cards and reloading the deck
    def clear_board
      @controller = GameController.new
      @playerHand = Hand.new
      @dealerHand = Hand.new
      @cardArPlayer.each { |x| x.clear  }
      @cardArDealer.each { |x| x.clear  }
      @winnerFlow.clear
      @dealerScore.clear
      @dealerWins.clear
      @dealerInfo.after(@dealerName) do
        @dealerScore = @shoes.para "??"
        @dealerWins = @shoes.para "Wins: #{@dealerWinsCount}"
      end
    end


    #handling the new game
    def new_game_start
      @hit.show
      @stay.show
      clear_board
      @controller.shuffle_deck
      @controller.draw_card(@playerHand)
      @controller.draw_card(@playerHand)
      @controller.draw_card(@dealerHand)
      @controller.draw_card(@dealerHand)
      @cardflowPlayer.append do
        @cardArPlayer << @shoes.image("Cards/#{@playerHand.get_hand_name(0)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
        @cardArPlayer << @shoes.image("Cards/#{@playerHand.get_hand_name(1)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
      end
      @cardflowDealer.append do
      @cardArDealer << @shoes.image("Cards/#{@dealerHand.get_hand_name(0)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
      @cardArDealer << @shoes.image("View_application/Card_Back.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
      end
      @playerScore.clear
      @playerWins.clear
      @playerInfo.after(@name) do
        @playerScore = @shoes.para "#{@playerHand.get_hand_score}"
        @playerWins = @shoes.para "Wins: #{@playerWinsCount}"
      end
    end

end# GameView
