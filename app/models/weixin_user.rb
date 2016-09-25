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

	def self.create_menu
		menu = %Q| {
			     "button":[
			      {	
			          "name":"人才评价",
			           "sub_button":[
			           {	
			               "type":"view",
			               "name":"协会简介",
			               "url":"http://weixin.cwrcpj.org/weixin/1/gota"
			            },
			            {
			               "type":"view",
			               "name":"评价办法",
			               "url":"http://weixin.cwrcpj.org/weixin/2/gota"
			            },
			            {
			               "type":"view",
			               "name":"评价机构",
			               "url":"http://m.cwrcpj.org/wx_auth?url=comment"
			            },
			            {
			               "type":"view",
			               "name":"申请评价",
			               "url":"http://weixin.cwrcpj.org/weixin/3/gota"
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
			               "url":"http://weixin.cwrcpj.org/weixin/4/gota"
			            },
			            {
			               "type":"view",
			               "name":"我的课程",
			               "url":"http://m.cwrcpj.org/wx_auth?url=my_course"
			            },
			            {
			               "type":"click",
			               "name":"退出",
			               "url":"http://m.cwrcpj.org/wx_auth?url=quit"
			            }]
			       }]
			 }|
		response = $client.create_menu(menu)
		Rails.logger.info "response===========#{response.inspect}"
	end

end
