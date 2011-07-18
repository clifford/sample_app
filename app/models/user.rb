class User < ActiveRecord::Base
  attr_accessor :password, :encrypted_password
  attr_accessible :name, :email, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
            :length => {:maximum => 50}
  validates :email, :presence => true,
            :format => {:with => email_regex},
            :uniqueness => {:case_sensitive => false}

  # automaticaly create the virtual attribute 'password_confirmation'
  validates :password, :presence => true,
	    :confirmation => true,
            :length => {:within => 6..40}

  before_save :encrypt_password # callback to encrypt_password before saving

  def has_password?(submitted_password)
    # compare encrypted pasword with the encrypted version of submitted_password
  end

  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
