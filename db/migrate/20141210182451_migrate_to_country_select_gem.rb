class MigrateToCountrySelectGem < ActiveRecord::Migration
  def up
    remove_column :donors, :country_id
    drop_table :countries
    add_column :donors, :country_code, :string
    add_index :donors, :country_code
  end

  def down
    create_table :countries do |t|
      t.string :name

      t.timestamps
    end
    add_column :donors, :country_id, :integer
    add_index :donors, :country_id
    remove_column :donors, :country_code
  end
end
