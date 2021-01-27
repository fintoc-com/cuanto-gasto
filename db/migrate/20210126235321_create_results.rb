class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.string :link_id, null: false, index: { unique: true }
      t.float :rappi_result
      t.float :uber_eats_result
      t.float :uber_result
      t.float :total_result

      t.timestamps
    end
  end
end
