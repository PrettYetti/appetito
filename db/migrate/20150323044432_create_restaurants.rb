class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :cuisine
      t.string :phone
      t.string :address
      t.float :rating
      t.integer :price
      t.references :event, index: true

      t.timestamps null: false
    end
  end
end
