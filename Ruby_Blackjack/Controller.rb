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

end
