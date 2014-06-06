module UserAuth
  module LocalStoreMode
    def self.included(base)
      base.send :include, Mongoid::Document
      base.send :include, Mongoid::Timestamps

      # Include default devise modules. Others available are:
      # :confirmable, :lockable, :timeoutable and :omniauthable
      base.send :devise, :database_authenticatable, :registerable,
             :recoverable, :rememberable, :trackable, :validatable

      base.send :field, :name
      ## Database authenticatable
      base.send :field, :login
      base.send :field, :email,              type: String, default: ""
      base.send :field, :encrypted_password, type: String, default: ""

      ## Recoverable
      base.send :field, :reset_password_token,   type: String
      base.send :field, :reset_password_sent_at, type: Time

      ## Rememberable
      base.send :field, :remember_created_at, type: Time

      ## Trackable
      base.send :field, :sign_in_count,      type: Integer, default: 0
      base.send :field, :current_sign_in_at, type: Time
      base.send :field, :last_sign_in_at,    type: Time
      base.send :field, :current_sign_in_ip, type: String
      base.send :field, :last_sign_in_ip,    type: String

      ## Confirmable
      # field :confirmation_token,   type: String
      # field :confirmed_at,         type: Time
      # field :confirmation_sent_at, type: Time
      # field :unconfirmed_email,    type: String # Only if using reconfirmable

      ## Lockable
      # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
      # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
      # field :locked_at,       type: Time
      base.extend ClassMethods
    end

    module ClassMethods
      def authenticate(email_or_login, password)
        user = self.where(:login => email_or_login).first
        user = self.where(:email => email_or_login).first if user.blank?
        valid = user.valid_password?(password) if !user.blank?
        return user if !!valid
        nil
      end

      def find_for_database_authentication(conditions)
        login = conditions.delete(:login)
        return self.where(:login => login.downcase).first if !login.blank?

        email = conditions.delete(:email)
        return self.where(:email => email.downcase).first if !email.blank?
        nil
      end
    end
  end
end

