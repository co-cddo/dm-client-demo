class AddSourceAndSourceDataToRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :records, :source, :string
    add_column :records, :source_data, :text
  end
end
