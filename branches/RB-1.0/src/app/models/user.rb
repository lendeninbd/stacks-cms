class User < ActiveRecord::Base
  
  has_many :documents
  
  validates_presence_of :username
  validates_presence_of :display_name
  validates_presence_of :email_address
  
  validates_uniqueness_of :username
  validates_uniqueness_of :display_name, :message => 'has already been taken'
  
  def password=(pass)
    salt = [Array.new(6) { rand(256).chr }.join].pack('m').chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass + salt)
  end
  
end
