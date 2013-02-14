class CreateHunts < ActiveRecord::Migration
  def change
    create_table :hunts do |t|
      t.integer :product_id
      t.string :voucher_code
      t.string :team_name
      t.string :email
      t.boolean :started
      t.boolean :paused
      t.boolean :completed
      t.datetime :started_at
      t.datetime :last_submitted
      t.boolean :current_clue
      t.string :current_status
      t.integer :time_taken

      t.timestamps
    end
  end
end
