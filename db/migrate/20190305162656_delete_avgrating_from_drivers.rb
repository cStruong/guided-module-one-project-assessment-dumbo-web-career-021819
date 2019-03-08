class DeleteAvgratingFromDrivers < ActiveRecord::Migration[5.2]
  def change
    remove_column :drivers, :avg_rating
  end
end
