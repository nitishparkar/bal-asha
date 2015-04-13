class CreateCallForActions < ActiveRecord::Migration
  def change
    create_table :call_for_actions do |t|
      t.datetime :date_of_action
      t.references :donor, index: true
      t.integer :status, default: 0
      t.integer :status, default: 0
      t.references :person, index: true
      t.text :remarks
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
