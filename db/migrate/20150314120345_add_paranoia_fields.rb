class AddParanoiaFields < ActiveRecord::Migration
  def up
    add_column :people, :deleted_at, :datetime, index: true
    add_column :donors, :deleted_at, :datetime, index: true
    add_column :donations, :deleted_at, :datetime, index: true
    add_column :purchases, :deleted_at, :datetime, index: true
    add_column :items, :deleted_at, :datetime, index: true
    add_column :categories, :deleted_at, :datetime, index: true
    remove_column :donations, :deleted
    remove_column :purchases, :deleted
    remove_column :items, :deleted
  end

  def down
    remove_column :people, :deleted_at
    remove_column :donors, :deleted_at
    remove_column :donations, :deleted_at
    remove_column :purchases, :deleted_at
    remove_column :items, :deleted_at
    remove_column :categories, :deleted_at
    add_column :donations, :deleted, :boolean, null: false, default: false
    add_column :purchases, :deleted, :boolean, null: false, default: false
    add_column :items, :deleted, :boolean, null: false, default: false
  end
end
