class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true
      t.string :name
      t.datetime :when
      t.string :location
      t.string :cuisine

      t.timestamps null: false
    end
    add_foreign_key :events, :users
  end
end
