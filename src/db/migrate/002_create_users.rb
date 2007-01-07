class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users do |t|
      t.column :username, :string
      t.column :display_name, :string
      t.column :password_salt, :string
      t.column :password_hash, :string
    end
    
    user = User.create(:username => 'stack', :display_name => 'Stack')
    user.password = '12345'
    user.save
  end

  def self.down
    drop_table :users
  end
  
end
