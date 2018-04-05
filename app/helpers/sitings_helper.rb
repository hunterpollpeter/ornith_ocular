module SitingsHelper
	def liked_siting(siting)
		if user_signed_in?
			if current_user.voted_for? siting
				return link_to '', unlike_siting_path(@siting), {remote: true, id: "like", class: "fas fa-heart"}
			else
				return link_to '', like_siting_path(@siting), {remote: true, id: "like", class: "far fa-heart"}
			end
		else 
			return link_to '', new_user_session_path, {id: "like", class: "far fa-heart"}
		end
	end

	def display_likes(siting)
		votes = siting.votes_for.up.by_type(User)
		return 'Be the first to like this!' if votes.size <= 0
		return list_likers(votes) if votes.size <= 8
		count_likers(votes)
	end

	def list_likers(votes)
		user_names = []
		unless votes.blank?
			votes.voters.each do |voter|
				user_names.push(voter.username)
			end
			user_names.to_sentence.html_safe + like_plural(votes)
		end
	end

	def count_likers(votes)
		vote_count = votes.size
		vote_count.to_s + ' likes'
	end

	def like_plural(votes)
		return ' like this' if votes.count > 1
		' likes this'
	end
end
