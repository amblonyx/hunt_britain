class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :product_code
      t.string :name
      t.string :format
      t.float :price
      t.string :data_file

      t.timestamps
    end
  end
end
