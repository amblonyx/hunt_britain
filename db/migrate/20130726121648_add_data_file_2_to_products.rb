class AddDataFile2ToProducts < ActiveRecord::Migration
  def change
	add_column :products, :data_file_2, :string
  end
end
