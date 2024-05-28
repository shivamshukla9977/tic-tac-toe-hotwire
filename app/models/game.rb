class Game < ApplicationRecord
    before_validation(on: :create) do 
        self.state = {
            0 => {0 => nil, 1 => nil, 2 => nil},
            1 => {0 => nil, 1 => nil, 2 => nil},
            2 => {0 => nil, 1 => nil, 2 => nil},
        }
        self.current_symbol = [:x, :o].sample
    end


    attr_accessor :winner, :finished

    validates :player1_name, presence: true
    validates :player2_name, presence: true

    after_update_commit { broadcast_update }

    def [](row,col)
        state[row.to_s][col.to_s]
    end
    
    def move!(row, col)
        # Make a mark at row/col
        state[row.to_s][col.to_s] = current_symbol.to_s

        # swap current symbol
        self.current_symbol = current_symbol == "x" ? "o" : "x"
        check_winner(row.to_i, col.to_i)
        self.save!
    end

    def finished?
        winner.present? || state.values.all? { |cols| cols.values.all?(&:present?) }
    end

    def check_winner(row, col)
        symbol = state[row.to_s][col.to_s]
        # Check horizontal
         
        if state[row.to_s].values.all? { |value| value == symbol }
          self.winner = symbol
          self.finished = true
          return
        end
        # Check vertical
        if state.all? { |r, cols| cols[col.to_s] == symbol }
          self.winner = symbol
          self.finished = true
          return
        end
        # Check diagonals
        if [state['0']['0'], state['1']['1'], state['2']['2']] == [symbol, symbol, symbol] ||
           [state['0']['2'], state['1']['1'], state['2']['0']] == [symbol, symbol, symbol]
          self.winner = symbol
          self.finished = true
          return
        end
        # Check for draw
        if state.values.all? { |cols| cols.values.all?(&:present?) }
          self.finished = true
        end
    end
end
