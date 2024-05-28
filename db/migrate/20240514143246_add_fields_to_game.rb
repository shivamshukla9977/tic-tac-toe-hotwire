class AddFieldsToGame < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :player1_name, :string
    add_column :games, :player2_name, :string
  end
end
