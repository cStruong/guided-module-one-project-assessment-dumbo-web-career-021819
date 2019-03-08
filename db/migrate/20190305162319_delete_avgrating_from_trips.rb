class DeleteAvgratingFromTrips < ActiveRecord::Migration[5.2]
  def change
    remove_column :trips, :avg_rating
  end
end
