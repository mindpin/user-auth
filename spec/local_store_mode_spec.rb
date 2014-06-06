require 'spec_helper'

class LocalStoreModeUser
  include UserAuth::LocalStoreMode
end

describe UserAuth::LocalStoreMode do
  describe "create" do
    it{
      LocalStoreModeUser.count.should == 0
      user = LocalStoreModeUser.create(
        :name     => "user_local_store_name",
        :login    => "user_local_store_login",
        :email    => "user_local_store@mindpin.com",
        :password => "12345678"
      )
      LocalStoreModeUser.count.should == 1
      user = LocalStoreModeUser.last
      user.name.should == "user_local_store_name"
      user.login.should == "user_local_store_login"
      user.email.should == "user_local_store@mindpin.com"

      user = LocalStoreModeUser.authenticate("user_local_store@mindpin.com","12345678")
      user.name.should == "user_local_store_name"
      user.login.should == "user_local_store_login"
      user.email.should == "user_local_store@mindpin.com"

      user = LocalStoreModeUser.authenticate("user_local_store_login","12345678")
      user.name.should == "user_local_store_name"
      user.login.should == "user_local_store_login"
      user.email.should == "user_local_store@mindpin.com"

      user = LocalStoreModeUser.authenticate("a","123")
      user.should == nil
      user = LocalStoreModeUser.authenticate("user_local_store_login","123")
      user.should == nil

      LocalStoreModeUser.find_for_database_authentication({})
    }
  end
end