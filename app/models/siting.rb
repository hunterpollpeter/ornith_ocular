class Siting < ApplicationRecord
	belongs_to :user

	has_many :comments, dependent: :destroy

	has_attached_file :image, styles: {small: "300x300#"}
	has_attached_file :static_map
	
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
	validates_attachment_content_type :static_map, content_type: /\Aimage\/.*\Z/

	validates :bird, presence: true
	validates :location, presence: true
	validates :longitude, presence: true
	validates :latitude, presence: true
	validates :image, presence: true

	acts_as_votable

	geocoded_by :location

	def self.search(search)
		if search && !search.empty?
			if (Geocoder.coordinates(search)) #bug??
				near(search, 100) + where("UPPER(bird) LIKE UPPER(?)", "%#{search}%")
			else
				where("UPPER(bird) LIKE UPPER(?)", "%#{search}%")
			end
		else
			all
		end
	end
end
