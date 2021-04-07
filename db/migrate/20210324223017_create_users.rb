class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.text :account_key, limit: 100
      t.text :email, limit: 200
      t.text :full_name, limit: 200
      t.text :key, limit: 100
      t.text :metadata, limit: 2500
      t.text :password_digest
      t.text :phone_number, limit: 20

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :full_name
    add_index :users, :metadata	
    add_index :users, :account_key, unique: true
  end

  def down
    drop_table :users
  end
end
