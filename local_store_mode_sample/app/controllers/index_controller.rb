class IndexController < ApplicationController
  def index
    if user_signed_in?
      return render "index/index"
    end
    redirect_to "/account/sign_in"
  end
end
