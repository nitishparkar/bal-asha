class AddTypeCdToPeople < ActiveRecord::Migration
  def change
    add_column :people, :type_cd, :integer, default: 0
  end
end
