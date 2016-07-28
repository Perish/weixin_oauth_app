class WeixinUser < ApplicationRecord
	serialize :privilege, JSON
	validates :openid, presence: true, uniqueness: true
	belongs_to :weixin_user_token, foreign_key: :openid
end
