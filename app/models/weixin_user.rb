class WeixinUser < ApplicationRecord
	serialize :privilege, JSON
	validates :openid, presence: true, uniqueness: true
	belongs_to :weixin_user_token


	def post_info(user_token)
		link = Link.first.link
		RestClient.post link, {user_token: user_token, weixin_user: self}.to_json, :content_type => :json, :accept => :json
	end

end
