class AddSourceAndSourceDataToRecords < ActiveRecord::Migration[8.0]
  def change
    change_table :records, bulk: true do |t|
      t.string :source
      t.text :source_data
    end
  end
end
