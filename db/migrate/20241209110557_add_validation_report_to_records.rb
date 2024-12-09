class AddValidationReportToRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :records, :validation_report, :text, array: true
  end
end
