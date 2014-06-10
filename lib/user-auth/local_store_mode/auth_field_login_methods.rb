module UserAuth
  module LocalStoreMode
    module AuthFieldLoginMethods
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:extend, ClassMethods)
      end

      module InstanceMethods
        #   1 去掉 email 默认的验证 def email_required?;false;end
        def email_required?
          false
        end

        def email_changed?
          false
        end
      end

      module ClassMethods
        def authenticate(login, password)
          user = self.where(:login => login).first
          valid = user.valid_password?(password) if !user.blank?
          return user if !!valid
          nil
        end

        #   2 自定义 find_for_database_authentication 只检查 login
        def find_for_database_authentication(conditions)
          login = conditions.delete(:login)
          self.where(:login => login).first
        end
      end
    end
  end
end