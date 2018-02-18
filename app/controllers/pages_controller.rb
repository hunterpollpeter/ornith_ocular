class PagesController < ApplicationController
	def map
		@title = 'Map'
		key = ENV['GOOGLE_MAPS_KEY']
		@source = "https://maps.googleapis.com/maps/api/js?key=#{key}&callback=initMap"
		sitingsArray = Array.new
		Siting.all.each do |siting|
			sitingsArray << {coords: {lat: siting.latitude, lng: siting.longitude}, image: siting.image.url(:small), url: siting_path(siting)}
		end
		@sitings = sitingsArray.to_json
	end
end
