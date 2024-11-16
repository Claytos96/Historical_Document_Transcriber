class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  # Store the URL the user was trying to access
  def store_user_location!
    # Store the location in the session only if it's a GET request and not an AJAX request
    # and the current path isn't related to Devise's login/signup
    if request.get? && !request.xhr? && !devise_controller? && !request.path.include?('login') && !request.path.include?('sign_up')
      session[:return_to] = request.fullpath
    end
  end

  # Determine if we should store the user's location
  def storable_location?
    !devise_controller? && !request.xhr? && !request.path.include?('login') && !request.path.include?('sign_up')
  end

end
