class AddRemoteIdToRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :records, :remote_id, :string
  end
end
