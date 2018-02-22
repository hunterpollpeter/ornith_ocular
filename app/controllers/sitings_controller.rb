require "open-uri"
require 'openssl'
# apparently not good for production, but okay for development
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class SitingsController < ApplicationController
	def index 
		@title = 'Sitings'
		@sitings = Siting.search(params[:search])
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

		location = Geocoder.search(@siting.location)[0]

		if(!location)
			@siting.errors.add(:location, "invalid")
			@title = "Create Siting"
			render 'new' and return
		end

		@siting.location   = get_location_name(location)
		@siting.latitude   = location.latitude
		@siting.longitude  = location.longitude
		@siting.static_map = get_static_map(@siting.latitude, @siting.longitude)

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
			location = Geocoder.search(params[:siting][:location])[0]

			if(!location)
				@siting.errors.add(:location, "invalid")
				@title = "Edit Siting"
				render 'edit' and return
			end

			params[:siting][:location] = get_location_name(location)

			@siting.latitude   = location.latitude
			@siting.longitude  = location.longitude
			@siting.static_map = get_static_map(@siting.latitude, @siting.longitude)
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

	private def get_static_map(latitude, longitude)
		center = [ latitude, longitude ].join(',')
		key = ENV['GOOGLE_MAPS_KEY']
		zoom = 6;
		color = "red";
		size = "300x300";
		open("https://maps.googleapis.com/maps/api/staticmap?center=#{center}&size=#{size}&zoom=#{zoom}&markers=color:#{color}%7C#{center}&key=#{key}")
	end

	private def get_location_name(location)
		return [location.city, location.state, location.country] * ", "
	end

end
