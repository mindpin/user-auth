class IndexController < ApplicationController
  def index
    if user_signed_in?
      return render "index/index"
    end
    redirect_to "/users/sign_in"
  end
end
