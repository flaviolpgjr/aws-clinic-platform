class AddPlatformRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :platform_role, :integer, null: false, default: 0
  end
end