class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes do |t|
      t.decimal :number, precision: 2, scale: 2

      t.timestamps
    end
  end
end
