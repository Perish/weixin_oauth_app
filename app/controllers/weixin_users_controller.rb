class WeixinUsersController < ApplicationController
  before_action :is_code?, only: [:code]

  def index
  	# 存储
  	session[:back_link] = params[:back_link] if params[:back_link].present?
  	session[:user_token] = params[:user_token] if params[:user_token].present?
  	wu = WeixinUser.find_by(openid: session[:openid])
  	if wu.present?
  		# 如果用户存在直接发送用户信息给接口
  		render json: wu
  	else
  		# 用户去认证
  		session.delete(:openid)
  		redirect_to $client.authorize_url(code_weixin_users_url, "snsapi_userinfo")
  	end
  end

  def code
  	# 获得openid和access_token
	sns_info = $client.get_oauth_access_token(params[:code])
	if sns_info.en_msg == "ok"
		# 保存或者更新weixin_user_token
		weixin_user_token = WeixinUserToken.deal_with_self(sns_info.result)
		if weixin_user_token&.id.present?
		  	session[:openid] = weixin_user_token.openid
		  	# 保存或者更新weixin_user
			weixin_user_token.deal_with_weixin_user
		end
		if weixin_user_token&.weixin_user
  			# 如果用户存在直接发送用户信息给接口
			render json: weixin_user_token&.weixin_user
  		else
			session.delete(:user_token)
  			redirect_to session.delete(:back_link)
  		end
	else 
		# 如果获得的access_token 为空就跳转到默认链接
		session.delete(:user_token)
		redirect_to session.delete(:back_link)
	end
  end


  # 发送客服消息
  def create
  	users_arr = params[:to_users]
  	content = params[:content]
  	if Domains::DOMAINS.include?(request.host) && users_arr.present? && content.present?
  		users_arr.each do |openid|
  			$client.send_text_custom(openid, content)
  		end
		render json: {status: "success"}  		
  	else
  		render json: {status: "fail"}
  	end
  end

  private

  def is_code?
  	if params[:code].blank?
		# 如果不存在就返回到默认链接
		session.delete(:user_token)
		redirect_to session.delete(:back_link) and return
  	end
  end

end
