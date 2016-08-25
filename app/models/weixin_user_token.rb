class WeixinUserToken < ApplicationRecord
	validates :openid, presence: true, uniqueness: true
	has_one :weixin_user

	# 创建或者更新access_token
	def self.deal_with_self(result)
	  	weixin_user_token = find_by(openid: result["openid"])
	  	result["expires_in"] -= 100
	  	return create(result) if weixin_user_token.blank?
	  	weixin_user_token.update(result)
	  	weixin_user_token
	end

	after_save :deal_with_weixin_user
	# 保存或者更新weixin_user
	def deal_with_weixin_user
		user_info = $client.get_oauth_userinfo(openid, access_token)
		if user_info.en_msg == "ok" 
			return create_weixin_user(user_info.result)  if weixin_user.blank?
			weixin_user.update(user_info.result)
		end
		weixin_user
	end

end
