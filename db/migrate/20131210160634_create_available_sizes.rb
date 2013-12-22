class CreateAvailableSizes < ActiveRecord::Migration
  def change
    create_table :available_sizes do |t|
      t.integer :product_id
      t.integer :size_id

      t.timestamps
    end
  end
end
