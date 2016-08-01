class Link < ApplicationRecord
	# link  链接
	# status
	belongs_to :user

	validates :link, presence: true
end
