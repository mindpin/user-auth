class IndexController < ApplicationController
  def index
    if !login?
      return render "index/login_form"
    end
    @user = current_user
  end

  def login
    email = params[:user][:email]
    password = params[:user][:password]
    user = User.authenticate(email, password)
    self.current_user = user if !user.blank?
    redirect_to "/"
  end

  def logout
    self.current_user = nil
    redirect_to "/"
  end

  private
  def current_user
    return User.find(session[:user_id]) if !session[:user_id].blank?
    nil
  end

  def login?
    !current_user.blank?
  end

  def current_user=(user)
    if !user.blank?
      session[:user_id] = user.id.to_s
    else
      session[:user_id] = nil
    end
  end
end