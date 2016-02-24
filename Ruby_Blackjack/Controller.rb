class GameController

    def initialize(shoes)
        @deck = Deck.new
        @shoes = shoes
    end

    def display_card(index)

        x = @deck.get_card_at_index(index)
        @shoes.image("Cards/#{x.get_name}.png", width: "20%", height: "22%")
    end

end
