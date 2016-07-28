class WeixinUserToken < ApplicationRecord
	validates :openid, presence: true, uniqueness: true
	belongs_to :weixin_user, foreign_key: :openid
end
