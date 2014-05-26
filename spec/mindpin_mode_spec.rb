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
end