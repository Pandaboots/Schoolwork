require_relative 'Controller'
require_relative 'Model_createDeck'
require_relative 'view_ConsolePlay'

print "Please Enter your name: "
#playerName = gets.chomp
continue = 1

print "\n-------------Welcome to blackjack!---------------------\n"

#create the game controller, dealer hand, and player hand, then shuffle the deck
game = GameController.new
dealer = Hand.new
player = Hand.new
game.shuffle_deck

#main game loop
while(continue == 1)
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

    #ask the player if they wish to hit or stay
    print "Would you like to: [hit] [stay] [fold]: "
    choice = gets.chomp

    #hit loop
    while(choice == "hit")
        game.draw_card(player)
        # =>if they get an ace, ask them if they want it to be for 1 or 11
        handle_ace(player)
        display_hand(player)
        print "\n\n"
        print "New hand: "
        display_hand(player)
        print "\n"
        print "Player score: #{player.get_hand_score} \n"
        print "Would you like to: [hit] [stay] [fold]: "
        choice = gets.chomp
    end

    if (choice == "fold" )
        print "you fold this hand, dealer wins."
    end
    if (player.get_hand_score > 21)
        print "you bust this round, dealer wins."
    end


    #calculate what the dealer should do
    #compare scores
    #declare winner and ask to play again
end
