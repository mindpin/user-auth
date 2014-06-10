module UserAuth
  module LocalStoreMode
    module AuthFieldEmailMethods
      def self.included(base)
        base.send(:extend, ClassMethods)
      end

      module ClassMethods
        def authenticate(email, password)
          user = self.where(:email => email).first
          valid = user.valid_password?(password) if !user.blank?
          return user if !!valid
          nil
        end

        #   1 自定义 find_for_database_authentication 只检查 email
        def find_for_database_authentication(conditions)
          email = conditions.delete(:email)
          self.where(:email => email).first
        end
      end
    end
  end
end