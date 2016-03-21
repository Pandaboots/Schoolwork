#####################################################
# => CONTROLLER.RB
# => Created by: Thomas Tracy
# => Purpose of this file is to act as a middle man
#    between the model and the view of the game. this
#    is where the rules for the ai of the dealer and the
#    ai are defined. as well as the hands of the players.
# => Created on: Feb 10, 2016
#####################################################



#GAMECONTROLLER
#simple class to hold the deck, shuffle the deck, pass out cards, etc.
class GameController
    #create a deck for this game
    def initialize()
        @deck = Deck.new
    end

    #draw a card off the top of the deck at a certain place
        #param: index - the place in the array of cards you would like
        #draw from
        #returns: the card drawn
    def draw_card_index(index)
        x = @deck.get_card_at_index(index)
    end

    #shuffle the deck so random cards may be drawn from the top
    def shuffle_deck()
        @deck.shuffle_list
    end

    #draw a card from the top of the deck
    #returns the drawn card
    #param: hand - the hand the card will be going to, either dealer or player
    def draw_card(hand)
        #pop the card
        x = @deck.pop_card_top
        #add it to the hand
        hand.add_hand(x)
    end
end




#HAND
#class used to hold the data of each card in a players hand. sort of generic,
#uses a function to handle the dealer AI, but I use the same class for the
#player as well.
class Hand

    def initialize()
        @hand = Array.new
        @score = 0
        @ace = 0
    end


    #add a card to this players hand
    def add_hand(card_to_add)
        @hand.push(card_to_add)

        #if there is an ace in hand, add one to the ace count
        if(card_to_add.get_value.to_i == 0)
            @ace += 1
        end
        @score += card_to_add.get_value.to_i
    end



    #get the name of a card in the dealers hand at a certain index
    #default is zero to show the first card of the dealer
    def get_hand_name(index)
        if(index < @hand.size)
            @hand[index].get_name
        end
    end


    #get the score for this players hand
    def get_hand_score
        @score
    end

    #get the count of aces in hand
    def get_ace_count
        @ace
    end

    #get a specific cards value at the index
    def get_hand_value(index)
        if(index < @hand.size)
            @hand[index].get_value
        end
    end


    #add the ace score to the hand
    def set_ace_score(aceScore)
        @score += aceScore
        #set the ace counter back to 0
        @ace -= 1
    end

    def get_hand_size
        @hand.size
    end

    #very simple AI to handle the dealers hand to know to hit or not
    def handle_dealer(game)
        # => if they have an ace, add 11
        while(@ace > 0)
            @score += 11
            @ace -= 1
            #if they are above 21, subtract 11 and add 1
            if(@score > 21)
                @score -= 10
            end
        end
        # => if its less then 17 hit
        while(@score <= 17)
            game.draw_card(self)
            # => if they have an ace, add 11
            while(@ace > 0)
                @score += 11
                @ace -= 1
                #if they are above 21, subtract 11 and add 1
                if(@score > 21)
                    @score -= 10
                end
            end
        end

        #return the score
        if(@score > 21)
            x = -1
        elsif(@score == 21)
            x = 0
        else
            x = @score
        end

    end

end
