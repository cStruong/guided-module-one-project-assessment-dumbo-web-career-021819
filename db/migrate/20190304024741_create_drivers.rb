class CreateDrivers < ActiveRecord::Migration[5.2]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :plates
      t.string :company
      t.float :avg_rating
    end
  end
end
