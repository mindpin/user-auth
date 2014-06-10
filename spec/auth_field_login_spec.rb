require 'spec_helper'

class AuthLoginUser
  include UserAuth::LocalStoreMode
  auth_field :login
end

class AuthLoginLengthUser
  include UserAuth::LocalStoreMode
  auth_field :login, :login_validate => {:length => {:in => 7..8}}
end

class AuthLoginFormatUser
  include UserAuth::LocalStoreMode
  auth_field :login, :login_validate => {:format => {:with => /\A[a-z0-9_]+\z/, :message => '只允许数字、字母和下划线'}}
end

describe UserAuth::LocalStoreMode::AuthFieldLoginMethods do
  it{
    AuthLoginUser.count.should == 0
    user = AuthLoginUser.create(
      :name     => "user_local_store_name",
      :login    => "__",
      :email    => "abc",
      :password => "12345678"
    )
    user.valid?.should == false
    user.errors.messages.should == {:login=>["只允许数字、字母", "is too short (minimum is 3 characters)"]}

    user = AuthLoginUser.create(
      :name     => "user_local_store_name",
      :login    => "1234",
      :email    => "abc",
      :password => "12345678"
    )
    user.valid?.should == true
    user.email.should == "abc"
  }

  it{
    AuthLoginLengthUser.count.should == 0
    user = AuthLoginLengthUser.create(
      :name     => "user_local_store_name",
      :login    => "__",
      :email    => "abc",
      :password => "12345678"
    )
    user.valid?.should == false
    user.errors.messages.should == {:login=>["只允许数字、字母", "is too short (minimum is 7 characters)"]}

    user = AuthLoginLengthUser.create(
      :name     => "user_local_store_name",
      :login    => "1234567",
      :email    => "abc",
      :password => "12345678"
    )
    user.valid?.should == true
    user.email.should == "abc"
  }


  it{
    AuthLoginFormatUser.count.should == 0
    user = AuthLoginFormatUser.create(
      :name     => "user_local_store_name",
      :login    => "__",
      :email    => "abc",
      :password => "12345678"
    )
    user.valid?.should == false
    user.errors.messages.should == {:login=>["is too short (minimum is 3 characters)"]}

    user = AuthLoginFormatUser.create(
      :name     => "user_local_store_name",
      :login    => "123456_7",
      :email    => "abc",
      :password => "12345678"
    )
    user.valid?.should == true
    user.email.should == "abc"
  }

  it "email 允许为空" do
    user = AuthLoginUser.create(
      :name     => "user_local_store_name",
      :login    => "1234",
      :email    => "",
      :password => "12345678"
    )
    user.valid?.should == true
    user.email.should == ""
  end

  it "email 格式随意" do
    user = AuthLoginUser.create(
      :name     => "user_local_store_name",
      :login    => "1234",
      :email    => "abc",
      :password => "12345678"
    )
    user.valid?.should == true
    user.email.should == "abc"
  end
end