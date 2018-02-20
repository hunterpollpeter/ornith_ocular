class PagesController < ApplicationController
	def map
		@title = 'Map'
		@id = params[:id]
		sitingsHash = Hash.new
		Siting.all.each do |siting|
			sitingsHash[siting.id] = {coords: {lat: siting.latitude, lng: siting.longitude}, image: siting.image.url(:small), url: siting_path(siting)}
		end
		@sitings = sitingsHash.to_json
	end
end
