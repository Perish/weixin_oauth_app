class WeixinUsersController < ApplicationController
  before_action :weixin_user
  before_action :is_code?, only: [:code]

  def index
  	# 存储
  	session[:path] = params[:path] if params[:path].present?
  	if @weixin_user.present?
  		render text: @weixin_user.inspect
  	else
  		redirect_to $client.authorize_url(code_weixin_users_url, "snsapi_userinfo")
  	end
  end

# https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect

  def code
  	# 获得openid和access_token
	sns_info = $client.get_oauth_access_token(params[:code])
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
  def token_save_or_update(result)
  	weixin_user_token = WeixinUserToken.find_by(openid: result["openid"])
  	result["expires_in"] -= 100
  	session[:openid] = result["openid"]
  	return WeixinUserToken.create(result) if weixin_user_token.blank?
  	weixin_user_token.update(result)
  	weixin_user_token
  end

  # 用户信息保存
  def user_info_save_or_update(wut)
	user_info = $client.get_oauth_userinfo(wut.openid, wut.access_token)
	return WeixinUser.create(user_info.result) if user_info.en_msg == "ok"
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
