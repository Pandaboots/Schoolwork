#####################################################
# => VIEW_GAMEVIEW.RB
# => Created by: Thomas Tracy
# => Purpose of this file is draw out the game board
#    with more visuals, using the same controller and
#    model that was used with the console version.
#    This is accomplished with through a gem called
#    green_shoes and will not compile unless that gem
#    is installed with your ruby compiler.
# => Created on: Feb 10, 2016
#####################################################




#CONSTANTS
#Constants that I may or may not have used because they did or did not work
# how I wanted
# -------
#ratio for card display widths
$CARD_WIDTH = 100
#ratio for card display heights
$CARD_HEIGHT = 150
#color for text
$WHITE = "#FFF"


#GAMEVIEW
#class used to draw out the board to show cards, score, and number of Wins
#for both the player and the dealer
class GameView
    def initialize(shoes)
        @shoes = shoes
        @controller = GameController.new
        @playerHand = Hand.new
        @dealerHand = Hand.new
    end

    #create the game view for the game to be played in
    def create_playerSpace

        #set up the game board
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
                #pictures of the cards for the dealer
                @cardflowDealer = @shoes.flow do
                  @cardArDealer = Array.new
                end
            end# dealerFlow

            #flow holding the horizontal space for the player
            @playerFLow = @shoes.flow(height: 250) do
                #stack holding relevant player information
                @playerInfo = @shoes.stack do
                  @name =  @shoes.para "Player "
                    @playerScore = @shoes.para "??"
                    @playerWins = @shoes.para "Wins: #{@playerWinsCount}"
                end# playerInfo
                #pictures of the cards for the player
                @cardflowPlayer = @shoes.flow do
                  @cardArPlayer = Array.new
                end
            end# playerflow
        end# gameStack

        #make room for the control buttons for the player to use to play the game
        @controlFlow = @shoes.flow do
            @newGame = @shoes.button("New Game")
            @hit = @shoes.button(    "   Hit  ")
            @stay = @shoes.button(   "  Stay  ")
            @hit.hide
            @stay.hide
        end# controlFlow

        #Show the results of the game to the player
        @winnerFlow = @shoes.flow do
          #the flow starts empty an is appended once the player decides to stay
        end

      #BUTTON CLICKS
        #handle the starting of a new game
        @newGame.click do
          new_game_start
        end
        #handle when the player hits
        @hit.click do
          hit
        end
        #handle when the player decides to stay
        @stay.click do
         stay
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
      #draw the new win count for the dealers hand
      @dealerInfo.after(@dealerName) do
        @dealerScore = @shoes.para "??"
        @dealerWins = @shoes.para "Wins: #{@dealerWinsCount}"
      end
    end# clear_board


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
      #draw the images of the cards to the players hands
      @cardflowPlayer.append do
        @cardArPlayer << @shoes.image("Cards/#{@playerHand.get_hand_name(0)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
        @cardArPlayer << @shoes.image("Cards/#{@playerHand.get_hand_name(1)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
        if(@playerHand.get_ace_count > 0)
          handle_ace(@playerHand)
        end
      end
      #draw the images of one card and a card back to the dealers hand
      @cardflowDealer.append do
        @cardArDealer << @shoes.image("Cards/#{@dealerHand.get_hand_name(0)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
        @cardArDealer << @shoes.image("View_application/Card_Back.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
      end
      #draw the new score for the players hand
      @playerScore.clear
      @playerWins.clear
      @playerInfo.after(@name) do
        @playerScore = @shoes.para "#{@playerHand.get_hand_score}"
        @playerWins = @shoes.para "Wins: #{@playerWinsCount}"
      end

    end

    #handle redrawing the players side of the board
    def hit
      #draw a card from the deck
      @controller.draw_card(@playerHand)
      @cardflowPlayer.append do
        @cardArPlayer << @shoes.image("Cards/#{@playerHand.get_hand_name(-1)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
      end
      #redraw the score
      @playerScore.clear
      @playerInfo.after(@name) do
        @playerScore = @shoes.para("#{@playerHand.get_hand_score}")
      end
      #check for a bust
      if(@playerHand.get_hand_score > 21)
       @winnerFlow.append  do
          @shoes.title "You Bust!", align: "center", stroke: "#FFF"
        end
        @dealerWinsCount += 1
        @hit.hide
        @stay.hide
      end
    end

    def stay
      @hit.hide
      @stay.hide
      #handle the dealer AI
      dealerScore = @dealerHand.handle_dealer(@controller)
      #show the dealers cards to the player
      i = 0
      @cardArDealer.each { |x| x.clear  }
      while( i < @dealerHand.get_hand_size)
        @cardflowDealer.append do
          @cardArDealer << @shoes.image("Cards/#{@dealerHand.get_hand_name(i)}.png",width:  $CARD_WIDTH, height: $CARD_HEIGHT)
        end
        i += 1
      end
      #redraw the dealers score
      @dealerScore.clear
      @dealerInfo.after(@dealerName) do
        @dealerScore = @shoes.para("#{@dealerHand.get_hand_score}")
      end
      #chose the winner
      if(dealerScore > @playerHand.get_hand_score || dealerScore == 0)
        #dealer wins hand
        @winnerFlow.append do
          @shoes.title "You Lose!", align: "center", stroke: "#FFF"
          @dealerWinsCount += 1
      end

      else
        #player wins hand
        @winnerFlow.append do
          @shoes.title "You Win!", align: "center", stroke: "#FFF"
          @playerWinsCount += 1
        end# append
      end# if

    end# stay


    def handle_ace(hand)

        Shoes.app width: 200, height: 200 do
          background ("#070")
          flow do
          para "You got an Ace!" align: "center"
          button('set the ace to 11'){
            hand.set_ace_score(11)
            close
          }
          button('set the ace to 1'){
            hand.set_ace_score(1)
            close
          }
        end
      end

    end


end# GameView
