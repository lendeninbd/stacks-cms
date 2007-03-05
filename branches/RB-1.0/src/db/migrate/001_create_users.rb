class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users do |t|
      t.column :username,         :string
      t.column :display_name,     :string
      t.column :email_address,    :string
      t.column :password_salt,    :string
      t.column :password_hash,    :string
      # Flags
      t.column :can_modify_users, :boolean, :default => false
      t.column :disabled,         :boolean, :default => false
      t.column :receives_errors,  :boolean, :default => false
    end
    
    user = User.create(:username => 'stack', 
      :display_name => 'Stack', 
      :email_address => 'stack@shortround.net', 
      :can_modify_users => true,
      :receives_errors => true)
    user.password = '12345'
    user.save
  end

  def self.down
    drop_table :users
  end
  
end
