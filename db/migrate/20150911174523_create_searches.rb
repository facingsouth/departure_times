class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :origin,       null: false
      t.string :destination,  null: false

      t.timestamps null: false
    end
  end
end
