module UserAuth
  module LocalStoreMode
    module AuthFieldEmailOrLoginMethods
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:attr_accessor, :email_or_login)
      end

      module ClassMethods
        def authenticate(email_or_login, password)
          user = self.where(:login => email_or_login.downcase).first
          user = self.where(:email => email_or_login.downcase).first if user.blank?
          valid = user.valid_password?(password) if !user.blank?
          return user if !!valid
          nil
        end

        #   2 自定义 find_for_database_authentication 检查 email 和 login
        def find_for_database_authentication(conditions)
          email_or_login = conditions.delete(:email_or_login).downcase
          user = self.where(:login => email_or_login).first
          user = self.where(:email => email_or_login).first if user.blank?
          return user
        end
      end
    end
  end
end