class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, null: false, default: ''
      t.text :remarks
      t.boolean :deleted, null: false, default: false
      t.text :meta_data
      t.timestamps
    end
  end
end
