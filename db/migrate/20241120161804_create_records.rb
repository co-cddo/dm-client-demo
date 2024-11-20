class CreateRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :records do |t|
      t.string :name
      t.json :metadata

      t.timestamps
    end
  end
end
