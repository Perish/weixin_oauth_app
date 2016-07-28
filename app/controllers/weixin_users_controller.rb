class WeixinUsersController < ApplicationController
  before_action :weixin_user
  before_action :is_code?, only: [:code]

  def index
  	# 存储
  	session[:path] = params[:path] if params[:path].present?
  	if @weixin_user.present?
  		render json: @weixin_user
  	else
  		redirect_to $client.authorize_url(code_weixin_users_url, "snsapi_userinfo")
  	end
  end

# https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect

  def code
  	# 获得openid和access_token
	sns_info = $client.get_oauth_access_token(params[:code])
	Rails.logger.info "sns_info==============#{sns_info.inspect}"
	if sns_info.en_msg == "ok"
		weixin_user_token = token_save_or_update(sns_info.result)
		wu = user_info_save_or_update(weixin_user_token)
		render json: wu
	else 
		# 如果获得的access_token 为空就跳转到默认链接
		# redirect_to session.delete(:path)
		render text: ""
	end
  end

  # 保存access_token 
  def token_save_or_update(sns_info)
  	weixin_user_token = WeixinUserToken.find_by(openid: sns_info["openid"])
  	sns_info["expires_in"] -= 100
  	return WeixinUserToken.create(sns_info) if weixin_user_token.blank?
  	weixin_user_token.update(sns_info)
  	weixin_user_token
  end

  # 用户信息保存
  def user_info_save_or_update(wut)
	user_info = $client.get_oauth_userinfo(wut.openid, wut.access_token)
	Rails.logger.info "user_info==============#{user_info.inspect}"
	if user_info.en_msg == "ok"
		wu = WeixinUser.create(user_info.result)
		session[:openid] = wu.openid
		wu
	end
  end

  private

  def is_code?
  	if params[:code].blank?
		# 如果不存在就返回到默认链接
		redirect_to session.delete(:path) and return
  	end
  end

  def weixin_user
  	@weixin_user = WeixinUser.find_by(openid: session[:openid])
  end

end
