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
      base.extend AuthFieldEmailOrLoginMethods::ClassMethods
      base.extend ClassMethods
      base.send :before_validation, :case_insensitive_fields
    end

    def case_insensitive_fields
      self.login = self.login.downcase if !self.login.blank?
      self.email = self.email.downcase if !self.email.blank?
    end

    module ClassMethods
      def auth_field(auth_field_name, options = {})
        auth_field_name = auth_field_name.to_sym
        case auth_field_name
        when :login
          self.send(:include, AuthFieldLoginMethods)
          #   3 增加 login validates
          self.__auth_field_add_login_validates(options)
        when :email
          self.send(:include, AuthFieldEmailMethods)
        when :email_or_login
          self.send(:include, AuthFieldEmailOrLoginMethods)
          #   1 增加 login validates
          self.__auth_field_add_login_validates(options)
        end
      end

      def __auth_field_add_login_validates(options)
        login_validate = options[:login_validate] || {}
        login_format = login_validate[:format] || {:with => /\A[a-z0-9]+\z/, :message => '只允许数字、字母'}
        login_length = login_validate[:length] || {:in => 3..20}
        self.send(:validates, :login, 
          :presence => true, 
          :uniqueness => {:case_sensitive => false},
          :format => login_format,
          :length => login_length
          )
      end
    end
  end
end

