class Siting < ApplicationRecord
	belongs_to :user

	has_many :comments, dependent: :destroy

	has_attached_file :image, styles: {small: "300x300#"}
	has_attached_file :static_map

	validates :bird, presence: true
	validates :location, presence: true
	validates :longitude, presence: true
	validates :latitude, presence: true
	validates :image, presence: true

	# image must be less than 3MB
	validates_attachment_size :image, :less_than => 3.megabytes

	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
	validates_attachment_content_type :static_map, content_type: /\Aimage\/.*\Z/

	acts_as_votable

	geocoded_by :location

	def self.search(search)
		if search && !search.empty?
			if (Geocoder.coordinates(search)) #bug??
				near(search, 100).order(created_at: :desc) + where("UPPER(bird) LIKE UPPER(?)", "%#{search}%").order(created_at: :desc)
			else
				where("UPPER(bird) LIKE UPPER(?)", "%#{search}%").order(created_at: :desc)
			end
		else
			all.order(created_at: :desc)
		end
	end
end
