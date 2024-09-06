class Changedocuments < ActiveRecord::Migration[7.1]
  def change
    remove_column :documents, :user_id_id
  end
end
