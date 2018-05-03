module UsersHelper
	def user_permitted(user)
		user == current_user || (current_user && current_user.admin?)
	end
end
