class User < ActiveRecord::Base
  
  has_many :posts
  
  def password=(pass)
    salt = [Array.new(6) { rand(256).chr }.join].pack('m').chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass + salt)
  end
  
end
