class WeixinUserToken < ApplicationRecord
	validates :openid, presence: true, uniqueness: true
	has_one :weixin_user, foreign_key: :openid
	
end
