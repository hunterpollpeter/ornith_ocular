class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
		@sitings = Siting.where(user_id: params[:id]).reverse
	end
end