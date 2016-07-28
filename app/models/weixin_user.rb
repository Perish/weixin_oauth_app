class WeixinUser < ApplicationRecord
	serialize :privilege, JSON
	validates :openid, presence: true, uniqueness: true
	has_one :weixin_user_token, foreign_key: :openid
end
