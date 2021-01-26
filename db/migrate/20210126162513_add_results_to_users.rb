class AddResultsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :rappi_result, :float
    add_column :users, :uber_eats_result, :float
    add_column :users, :uber_result, :float
    add_column :users, :total_result, :float
  end
end
