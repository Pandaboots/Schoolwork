

#handle aces in the console view
def handle_ace(hand)
    while(hand.get_ace_count.to_i > 0)
        print "You got an ace! is it worth 1 or 11? "
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
