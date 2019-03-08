class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.integer :passenger_id
      t.integer :driver_id
      t.integer :trip_rating
      t.timestamps
    end
  end
end
