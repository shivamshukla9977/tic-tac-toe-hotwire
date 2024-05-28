class GamesController < ApplicationController
    def index 
        @games = Game.all
    end
      
    def show 
        @game = Game.find(params[:id])
    end

    def create 
        player1_name = params[:player1_name]
        player2_name = params[:player2_name]
        @game = Game.create(player1_name: player1_name, player2_name: player2_name)
        redirect_to @game
    end
    def update
        @game = Game.find(params[:id])
        @game.update(game_params)
        redirect_to @game
    end

    def end_turn
        @game = Game.find(params[:id])
        @game.update(current_symbol: @game.current_symbol == 'o' ? 'x' : 'o')
        redirect_to @game
    end

    private
    def game_params
        params.permit(:player1_name, :player2_name)
    end
end
