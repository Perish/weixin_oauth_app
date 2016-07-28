class WeixinUserToken < ApplicationRecord
	validates :openid, presence: true, uniqueness: true
	has_one :weixin_user
end
