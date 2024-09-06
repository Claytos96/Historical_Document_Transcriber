class AddUserDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :user, :reference
  end
end
