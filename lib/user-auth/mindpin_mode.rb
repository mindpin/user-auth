require 'rest_client'

module UserAuth
  module MindpinMode
    AUTH_URL = "http://4ye.mindpin.com/account/sign_in"

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
        info = JSON.parse(response)
        store = find_or_create_by(:email => info["email"])
        store.update_attributes(
          :name   => info["name"], 
          :avatar => info["avatar"], 
          :uid    => info["id"], 
          :secret => info["secret"]
        )
        store.save
        store
      rescue
        nil
      end
    end
  end
end