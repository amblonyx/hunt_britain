class ChangeCurrentClueOfHunts < ActiveRecord::Migration
def up
# change_column :hunts, :current_clue, :integer
connection.execute(%q{
alter table hunts
alter column current_clue
type integer using cast(current_clue as integer)
})
end

  def down
  end
end
