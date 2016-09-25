class Qrcode < ApplicationRecord
	default_scope -> {order(created_at: :desc)}

	def qrcode_default_url
		"https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{ticket}"
	end
end
