require 'spec_helper'

class AuthEmailUser
  include UserAuth::LocalStoreMode
  auth_field :email
end

describe UserAuth::LocalStoreMode::AuthFieldEmailMethods do
  it{
    AuthEmailUser.count.should == 0
    user = AuthEmailUser.create(
      :name     => "user_local_store_name",
      :login    => "__",
      :email    => "abc",
      :password => "12345678"
    )
    user.valid?.should == false
    user.errors.messages.should == {:email=>["is invalid"]}

    user = AuthEmailUser.create(
      :name     => "user_local_store_name",
      :login    => "",
      :email    => "",
      :password => "12345678"
    )
    user.valid?.should == false
    user.errors.messages.should == {:email=>["can't be blank"]}

    user = AuthEmailUser.create(
      :name     => "user_local_store_name",
      :login    => "1",
      :email    => "abc@1.com",
      :password => "12345678"
    )
    user.valid?.should == true
    user.email.should == "abc@1.com"
  }

  it "login 可以为空" do
    user = AuthEmailUser.create(
      :name     => "user_local_store_name",
      :login    => "",
      :email    => "abc@1.com",
      :password => "12345678"
    )
    user.valid?.should == true
    user.login.should == ""
  end

  it "login 格式长度随意" do
    user = AuthEmailUser.create(
      :name     => "user_local_store_name",
      :login    => "~",
      :email    => "abc@1.com",
      :password => "12345678"
    )
    user.valid?.should == true
    user.login.should == "~"
  end
end