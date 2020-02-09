class PasswordsController < Devise::PasswordsController

  def edit
    super
    redirect_to "#{params[:redirect_url]}/#{params[:reset_password_token]}"
  end
end