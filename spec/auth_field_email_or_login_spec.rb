require 'spec_helper'

class AuthEmailOrLoginUser
  include UserAuth::LocalStoreMode
  auth_field :email_or_login
end

class AuthEmailOrLoginLengthUser
  include UserAuth::LocalStoreMode
  auth_field :email_or_login, :login_validate => {:length => {:in => 7..8}}
end

describe UserAuth::LocalStoreMode::AuthFieldEmailMethods do
  it{
    user = AuthEmailOrLoginUser.create(
      :name     => "user_local_store_name",
      :login    => "",
      :email    => "",
      :password => "12345678"
    )
    user.valid?.should == false
    user.errors.messages.should == {:email=>["can't be blank"], :login=>["can't be blank", "只允许数字、字母", "is too short (minimum is 3 characters)"]}
  }

  it{
    user = AuthEmailOrLoginLengthUser.create(
      :name     => "user_local_store_name",
      :login    => "",
      :email    => "",
      :password => "12345678"
    )
    user.valid?.should == false
    user.errors.messages.should == {:email=>["can't be blank"], :login=>["can't be blank", "只允许数字、字母", "is too short (minimum is 7 characters)"]}
  }  
end