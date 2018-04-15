class ApplicationController < ActionController::Base
  	protect_from_forgery with: :exception
	before_action :store_user_location!, if: :storable_location?
  	before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :first_name, :last_name, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs << :avatar
  end

 	def after_sign_in_path_for(resource)
		stored_location_for(resource) || root_path
	end

	private
    # Its important that the location is NOT stored if:
    # - The request method is not GET (non idempotent)
    # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an 
    #    infinite redirect loop.
    # - The request is an Ajax request as this can lead to very unexpected behaviour.
    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
    end

    def store_user_location!
      # :user is the scope we are authenticating
      store_location_for(:user, request.fullpath)
    end
end