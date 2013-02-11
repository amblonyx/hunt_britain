class AddDataFileToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :data_file, :string
  end
end
