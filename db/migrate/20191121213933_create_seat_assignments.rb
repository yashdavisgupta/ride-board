class CreateSeatAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :seat_assignments do |t|
      t.references :ride, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :seat_assignments, [:ride_id, :user_id], unique: true

    add_column :rides, :seats, :integer
  end
end
