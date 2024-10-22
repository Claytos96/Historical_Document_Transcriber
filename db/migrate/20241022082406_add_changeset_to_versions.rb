class AddChangesetToVersions < ActiveRecord::Migration[7.1]
  def change
    add_column :versions, :changeset, :text
  end
end
