class DecoupleClinicsFromAuthService < ActiveRecord::Migration[8.1]
  def change
    remove_reference :memberships, :clinic, foreign_key: true

    add_column :memberships, :clinic_id, :uuid, null: false
    add_index :memberships, [:user_id, :clinic_id], unique: true

    drop_table :clinics do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end