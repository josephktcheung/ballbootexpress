class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.string :link
      t.integer :color_id
      t.integer :brand_id
      t.integer :type_id

      t.timestamps
    end
    add_index :products, :color_id
    add_index :products, :brand_id
    add_index :products, :type_id
  end
end
