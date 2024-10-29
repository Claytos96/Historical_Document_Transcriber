class AddLockedToDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :locked, :boolean, default: false
  end
end
