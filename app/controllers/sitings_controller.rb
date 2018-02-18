require "open-uri"
require 'openssl'
# apparently not good for production, but okay for development
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class SitingsController < ApplicationController
	def index 
		@title = 'Sitings'
		@sitings = Siting.all
	end

	def show
		@siting = Siting.find(params[:id])
		@title = @siting.bird
	end

	def new
		@title = "Create Siting"
		@siting = Siting.new
	end

	def create
		@siting = Siting.new(siting_params.merge(static_map: static_map(params[:siting][:latitude], params[:siting][:longitude])))

		if(@siting.save)
			redirect_to @siting
		else
			render 'new' 
		end
	end

	def edit
		@title = "Edit Siting"
		@siting = Siting.find(params[:id])
	end

	def update
		@siting = Siting.find(params[:id])

		if(@siting.update(siting_params.merge(static_map: static_map(params[:siting][:latitude], params[:siting][:longitude]))))
			redirect_to @siting
		else
			render 'edit' 
		end
	end

	def destroy
		@siting = Siting.find(params[:id])
		@siting.destroy

		redirect_to sitings_path
	end

	private def siting_params
		params.require(:siting).permit(:bird, :longitude, :latitude, :image)
	end

	private def static_map(latitude, longitude)
		center = [ latitude, longitude ].join(',')
		key = ENV['GOOGLE_MAPS_KEY']
		zoom = 6;
		color = "red";
		size = "300x300";
		open("https://maps.googleapis.com/maps/api/staticmap?center=#{center}&size=#{size}&zoom=#{zoom}&markers=color:#{color}%7C#{center}&key=#{key}")
	end

end
