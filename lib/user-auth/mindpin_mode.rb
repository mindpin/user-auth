require 'rest_client'

module UserAuth
  module MindpinMode
    AUTH_URL = "http://4ye.mindpin.com/account/sign_in"
    USER_INFO_URL  = "http://4ye.mindpin.com/api/user_info"

    def self.included(base)
      base.extend ClassMethods
      base.send(:include, Mongoid::Document)
      base.send(:include, Mongoid::Timestamps)

      base.send(:field, :secret, :type => String)
      base.send(:field, :uid, :type => String)
      base.send(:field, :name, :type => String)
      base.send(:field, :email, :type => String)
      base.send(:field, :avatar, :type => String)
    end

    module ClassMethods
      def authenticate(email, password)
        params = {:user => {:login => email, :password => password}}
        response = RestClient.post(AUTH_URL, params)
        return if response.code != 200

        user_info = JSON.parse(response)
        _create_or_update_user_info(user_info)
      rescue
        nil
      end

      def get_by_secret(secret)
        store = where(:secret => secret).first
        return store if !store.blank?

        response = RestClient.get(_user_info_url(secret))
        return if response.code != 200

        user_info = JSON.parse(response)
        return if user_info["email"].blank?

        _create_or_update_user_info(user_info)
      rescue
        nil
      end

      def _create_or_update_user_info(user_info)
        store = find_or_create_by(:email => user_info["email"])
        store.update_attributes(
          :name   => user_info["name"], 
          :avatar => user_info["avatar"], 
          :uid    => user_info["id"], 
          :secret => user_info["secret"]
        )
        store.save
        store
      end

      def _user_info_url(value)
        "#{USER_INFO_URL}?secret=#{value}"
      end
    end
  end
end