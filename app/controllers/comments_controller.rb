class CommentsController < ApplicationController
	def create
		@siting = Siting.find(params[:siting_id])
		@comment = @siting.comments.build(params[:comment].permit(:body))
		@comment.user_id = current_user.id
		if @comment.save
			respond_to do |format|
				format.html { redirect_to root_path }
				format.js
			end
		else
			flash.now[:danger] = "error"
		end
	end

	def destroy
		@siting = Siting.find(params[:siting_id])
		@comment = @siting.comments.find(params[:id])
		@comment.destroy
		redirect_to siting_path(@siting)
	end
end
