class WeixinUser < ApplicationRecord
	serialize :privilege, JSON
	validates :openid, presence: true, uniqueness: true
	belongs_to :weixin_user_token
	has_many :weixin_openids

	def post_info(user_token, sing=0)
		link = if sing.to_i == 1
			Link.where(link_type: 1).first&.link
		else
			Link.where(link_type: 0).first&.link
		end
		Rails.logger.info "link-------post-info-------#{link}"
		RestClient.post link, {user_token: user_token, weixin_user: self, weixin_openids: openids}.to_json, :content_type => :json, :accept => :json
	end

	def openids
		weixin_openids.select(:apid, :openid)
	end

	def apids
		weixin_openids.to_a.map(&:apid).uniq
	end

end
