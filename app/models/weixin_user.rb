class WeixinUser < ApplicationRecord
	serialize :privilege, JSON
	validates :openid, presence: true, uniqueness: true
	belongs_to :weixin_user_token, optional: true
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

	def self.deal_scan(xml)
		wu = WeixinUser.where(openid: xml[:FromUserName]).first_or_initialize do |user|
			user.scene = xml[:EventKey]
		end
		if wu.persisted?
			wu.update_column(:scene, xml[:EventKey].gsub("qrscene_", "")) if xml[:EventKey].present? && wu.scene.blank?
		else
			user_info = $client.user(xml[:FromUserName])
			if user_info.en_msg == "ok"
				result = user_info.result
				wu.attributes = result.to_hash.slice(*attribute_names)
				wu.save
			end
		end
	end

	def openids
		weixin_openids.select(:apid, :openid)
	end

	def apids
		weixin_openids.to_a.map(&:apid).uniq
	end

	def self.create_menu
		menu = %Q| {
			     "button":[
			      {	
			          "name":"人才评价",
			           "sub_button":[
			           {	
			               "type":"view",
			               "name":"协会简介",
			               "url":"http://mp.weixin.qq.com/s?__biz=MzAwNzQxNjg1NQ==&mid=501869427&idx=1&sn=aff1b42600aac7f8a55bdae00fa1e59d&scene=1&srcid=0926gjwpZwPUNaMpjhEb1UYN#rd"
			            },
			            {
			               "type":"view",
			               "name":"评价办法",
			               "url":"http://mp.weixin.qq.com/s?__biz=MzAwNzQxNjg1NQ==&mid=501869433&idx=1&sn=576aac6ae3f3af4b37ae57c5644a8d76&scene=1&srcid=0926IMrCLSTYFLfJqBzzynM9#rd"
			            },
			            {
			               "type":"view",
			               "name":"评价机构",
			               "url":"http://m.cwrcpj.org/wx_auth?url=comment"
			            },
			            {
			               "type":"view",
			               "name":"申请评价",
			               "url":"http://www.cwrcpj.org/_client/goToAuth?redirectUrl=http://www.cwrcpj.org:8051/personalInfor.html"
			            }]
			      },
			      {
			           "name":"学习中心",
			           "sub_button":[
			           {	
			               "type":"view",
			               "name":"线上课程",
			               "url":"http://m.cwrcpj.org/wx_auth?url=index"
			            },
			            {
			               "type":"view",
			               "name":"线下课程",
			               "url":"http://m.cwrcpj.org/wx_auth?url=offline"
			            }]
			       },
			      {
			           "name":"我的",
			           "sub_button":[
			           {	
			               "type":"view",
			               "name":"我的评价",
			               "url":"http://www.cwrcpj.org/_client/goToAuth?redirectUrl=http://www.cwrcpj.org:8051/applyEvaluate.html"
			            },
			            {
			               "type":"view",
			               "name":"我的课程",
			               "url":"http://m.cwrcpj.org/wx_auth?url=my_course"
			            },
			            {
			               "type":"view",
			               "name":"退出",
			               "url":"http://m.cwrcpj.org/wx_auth?url=quit"
			            }]
			       }]
			 }|
		response = $client.create_menu(menu)
		Rails.logger.info "response===========#{response.inspect}"
	end

end
