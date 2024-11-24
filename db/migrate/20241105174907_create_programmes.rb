class CreateProgrammes < ActiveRecord::Migration
  def change
    create_table :programmes do |t|
      t.string :name, null: false, unique: true
      t.string :label, null: false

      t.timestamps
    end

    add_index :programmes, :name, unique: true
  end
end
