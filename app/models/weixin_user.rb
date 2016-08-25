class WeixinUser < ApplicationRecord
	serialize :privilege, JSON
	validates :openid, presence: true, uniqueness: true
	belongs_to :weixin_user_token
	has_many :weixin_openids

	def post_info(user_token)
		link = Link.first.link
		Rails.logger.info "link-------post-info-------#{link}"
		RestClient.post link, {user_token: user_token, weixin_user: self, weixin_openids: openids}.to_json, :content_type => :json, :accept => :json
	end

	def openids
		weixin_openids.to_a.map(&:openid).uniq
	end

end
