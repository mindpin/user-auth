require 'spec_helper'

class MindpinModeUser
  include UserAuth::MindpinMode
end

describe UserAuth::MindpinMode do
  describe "authenticate" do
    it{
      user = MindpinModeUser.authenticate("test@mindpin.com","123456")
      user.name.should == "mindpin_test"
      user.email.should == "test@mindpin.com"

      user = MindpinModeUser.authenticate("test@mindpin.com","123")
      user.should == nil
    }
  end

  describe "get_by_secret" do
    it{
      secret = "ae7ea4f083de9a0ff02e1ca6f927b3ad"
      user = MindpinModeUser.get_by_secret(secret)
      user.name.should == "mindpin_test"
      user.email.should == "test@mindpin.com"

      user = MindpinModeUser.get_by_secret("taasdfsdf")
      user.should == nil
    }
  end
end