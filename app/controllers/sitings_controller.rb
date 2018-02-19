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
		@siting = Siting.new(siting_params)

		coords = Geocoder.coordinates(@siting.location)
		if(!coords)
			@siting.errors.add(:location, "invalid")
			render 'edit' and return
		end

		@siting.latitude   = coords[0]
		@siting.longitude  = coords[1]
		@siting.static_map = static_map(@siting.latitude, @siting.longitude)

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

		if (@siting.location != params[:siting][:location])
			coords = Geocoder.coordinates(@siting.location)
			if(!coords)
				@siting.errors.add(:location, "Invalid location")
				render 'edit' and return
			end

			@siting.latitude   = coords[0]
			@siting.longitude  = coords[1]
			@siting.static_map = static_map(@siting.latitude, @siting.longitude)
		end

		if(@siting.update(siting_params))
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
		params.require(:siting).permit(:bird, :location, :image)
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
