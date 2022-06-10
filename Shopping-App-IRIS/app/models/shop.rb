class Shop < ApplicationRecord
	has_many_attached :images
	validates :title, presence: true
	validates :description, presence: true
	validate :image_type
	validates :excost, presence: true
	belongs_to :user
	validates_presence_of :user
	

	def thumbnail input
		return self.images[input].variant(resize: '300x300!').processed
	end

	private
	def image_type
		if images.attached? == false
			errors.add(:images, "are missing!")	
		end
		images.each do |image|
			if !image.content_type.in?(%('image/jpeg image/png'))
				errors.add(:images, 'needs to be a JPEG or PNG')
			end	
		end
	end
end
