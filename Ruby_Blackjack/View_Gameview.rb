#class to gather up the cards and put them into a deck
class GameView
    def initialize(shoes)
        @shoes = shoes
    end

    #create the game view and then and then pass to controller
    def create_view
        @controller = GameController.new(@shoes)

        @shoes.flow do
            @inputLine = @shoes.edit_line
            @OKButton = @shoes.button("OK")
        end

        @cardImage = @shoes.image("Card_Back.png", width: "20%", height: "22%")

        @OKButton.click do
            @cardImage.remove
            @cardImage = @controller.display_card(@inputLine.text.to_i)

        end

    end
end
