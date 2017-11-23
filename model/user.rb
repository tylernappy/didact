class User < ActiveRecord::Base
    validates :name, presence: true
    validates :company, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true

    include BCrypt

    def password
      @password ||= Password.new(password_hash)
    end

    def password=(new_password)
        @password = Password.create(new_password)
        self.password_hash = @password
    end
end
