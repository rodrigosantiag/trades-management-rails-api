# frozen_string_literal: true

# Confirmations controllers on application's scope rewrite Devise::ConfirmationsController necessary methods
class ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for(_resource_name, _resource)
    params[:redirect_url]
  end
end
