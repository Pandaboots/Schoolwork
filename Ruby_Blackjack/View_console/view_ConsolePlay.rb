#handle aces in the console view
def handle_ace(hand)
    while(hand.get_ace_count.to_i > 0)
        print "\nYou got an ace! is it worth 1 or 11? "
        aceScore = (gets.chomp).to_i
        hand.set_ace_score(aceScore)
    end
end



#displays all cards in a given hand to the console
def display_hand(hand)
    i = 0
    while(i < hand.get_hand_size)
        print "[#{hand.get_hand_name(i)}] "
        i += 1
    end

end



#starting point for the main game loop
def start_game

    continue = "y"

    print "\n\n\n--- Welcome to blackjack! ---\n"
    print "--- Dealing out a new hand ---\n\n"
    #create the game controller, dealer hand, and player hand, then shuffle the deck
    game = GameController.new
    dealer = Hand.new
    player = Hand.new
    game.shuffle_deck

    #main game loop

        #draw the starting hands
        game.draw_card(dealer)
        game.draw_card(dealer)
        game.draw_card(player)
        game.draw_card(player)

        #display the starting hands and scores

        print "Dealer hand: "
        display_hand(dealer)
        print "\n\n"

        print "Player hand: "
        display_hand(player)
        print "\n"


        #if there is aces in hand, calculate the score
        handle_ace(player)
        #show the players score
        print "Player score: #{player.get_hand_score} \n"
        print "---\n"


        begin
            #ask the player if they wish to hit or stay
            print "Would you like to: [hit] [stay] [fold]: "
            choice = gets.chomp

            case choice
            when "hit"
                #player hits, get them a new card
                player_hit(player, game)
            when "stay"
                print "--- staying with this hand ---\n"
            when "fold"
                print "--- you fold this hand, dealer wins. ---\n"
                exit
            else
                "'#{choice}' isn't a valid choice, please try again."
            end
        end while (choice != "stay" && choice != "fold")


        if (player.get_hand_score > 21)
            print "--- you bust this round, dealer wins. ---\n"
            #restart game
            exit
        end

        #calculate what the dealer should do
        print "\n\n--- the dealer is now playing thier hand ---"
        dealer_score = dealer.handle_dealer(game)
        print "\nFinal player hand: "
        display_hand(player)
        print "\nFinal player score: #{player.get_hand_score}"
        print "\nFinal dealer hand: "
        display_hand(dealer)
        print "\nFinal dealer score: #{dealer.get_hand_score}"


        #check scores and determine the winner
        if    (dealer_score == -1)
            print "\n\n --- DEALER BUSTS! PLAYER WINS! ---\n\n"
        elsif (dealer_score == 0)
            print "\n\n--- DEALER GETS BLACKJACK! DEALER WINS! ---\n\n"
        elsif (dealer_score >= player.get_hand_score)
            print "\n\n--- DEALER WINS! ---\n\n"
        else
            print "\n\n--- PLAYER WINS! ---\n\n"
        end

end


def player_hit(player, game)

        print "\n---   you hit!   ---"
        game.draw_card(player)
        # =>if they get an ace, ask them if they want it to be for 1 or 11
        handle_ace(player)
        print "\n\n"
        print "New hand: "
        display_hand(player)
        print "\n"
        print "New score: #{player.get_hand_score} \n"

end
