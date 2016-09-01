class Link < ApplicationRecord
	# link  链接
	# status
	belongs_to :user
	

	validates :link, presence: true

	def self.types
		[{"0" => "生产", "1" => "测试"}]
	end
end
