class Dropuser < ActiveRecord::Migration[7.1]
  def change
    if table_exists?(:users)
      drop_table :users
    end
  end
end
