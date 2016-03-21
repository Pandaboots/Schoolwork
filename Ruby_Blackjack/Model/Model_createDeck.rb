#####################################################
# => MODEL_CREATEDECK.RB
# => Created by: Thomas Tracy
# => This file sets up the data structures for the
#    the deck and cards.
# => Created on: Feb 10, 2016
#####################################################

#global variable holding the filename for the list of card names
$CARD_LIST_FILE = "CardList.txt"

#class that generates a deck of 52 cards and stores them into an array
class Deck

    def initialize
        @cardList = Array.new
        #open the file with the cards
        file = File.new($CARD_LIST_FILE, "r")
        #get the next picture in the list and chomp the ending /n
        #grab the value of the card
        x = 0
        while(line = file.gets)
            line = line.chomp
            value = file.gets.chomp
            @cardList.push(Card.new(line, value))
        end
    end

    #accessor to the card using the list
    def get_card_at_index(index)
        x = @cardList[index]
    end

    #shuffle the deck using .shuffle
    def shuffle_list
        @cardList.shuffle!
    end

    #pops a card off the top of the deck
    def pop_card_top
        @cardList.pop
    end

end

#simple class that just stores the name and value of a given card
class Card

    def initialize(cardName, cardValue)
        @name = cardName
        @value = cardValue
    end

    #returns the name of the card
    def get_name
        @name
    end

    #returns the value of the card
    def get_value
        @value.to_i
    end

end
