module UserAuth
  module LocalStoreMode
    module AuthFieldEmailOrLoginMethods
      def self.included(base)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods
        def authenticate(email_or_login, password)
          user = self.where(:login => email_or_login).first
          user = self.where(:email => email_or_login).first if user.blank?
          valid = user.valid_password?(password) if !user.blank?
          return user if !!valid
          nil
        end

        #   2 自定义 find_for_database_authentication 检查 email 和 login
        def find_for_database_authentication(conditions)
          login = conditions.delete(:login)
          return self.where(:login => login).first if !login.blank?

          email = conditions.delete(:email)
          return self.where(:email => email).first if !email.blank?
          nil
        end
      end
    end
  end
end