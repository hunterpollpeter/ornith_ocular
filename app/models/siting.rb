class Siting < ApplicationRecord
	has_attached_file :image, styles: {small: "300x300#"}
	has_attached_file :static_map
	
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
	validates_attachment_content_type :static_map, content_type: /\Aimage\/.*\Z/

	validates :bird, presence: true
	validates :location, presence: true
	validates :longitude, presence: true
	validates :latitude, presence: true
	validates :image, presence: true

	geocoded_by :location

	def self.search(search)
		if search && !search.empty?
			radius = 100;
			near(search, radius) + where("bird LIKE ?", "%#{search}%")
		else
			all
		end
	end
end
