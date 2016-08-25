class WeixinUsersController < ApplicationController
  before_action :is_code?, only: [:code]

  before_action :find_session_weixin_user, only: :index

  def index
  		# 如果用户存在直接发送用户信息给接口
      next_redirect(@wu)
  end

  def code
    begin 
      if params["state"] == "weixin"
      	# 获得openid和access_token
      	sns_info = $client.get_oauth_access_token(params[:code])
      	if sns_info.en_msg == "ok" 
      		# 保存或者更新weixin_user_token 如果用户存在直接发送用户信息给接口
      		token = WeixinUserToken.deal_with_self(sns_info.result)
          @wu = token&.weixin_user
          # token&.weixin_user&.post_info(session[:user_token])
          session[:openid] = sns_info.result["openid"] if sns_info.result["openid"]
      	end
      end

      if params["state"] =~ /\d/
        apid, wuid = params["state"].split("A")
        client = case apid
                  when "1" then $client1
                  when "2" then $client2
                  end
        @wu = WeixinUser.find_by(id: wuid)
        sns_info = client.get_oauth_access_token(params[:code])
        Rails.logger.info "code------stateid-----snsn--------#{sns_info.result.inspect}"
        if sns_info.en_msg == "ok" && @wu.present?
          @wu.weixin_openids.create(openid: sns_info.result["openid"], apid: apid)
        end
      end
      next_redirect(@wu)
    rescue Exception => e
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

  def find_session_weixin_user
    # 存储
    session[:back_link] = params[:back_link] if params[:back_link].present?
    session[:user_token] = params[:user_token] if params[:user_token].present?
    @wu = WeixinUser.find_by(openid: session[:openid])
    if @wu.blank?
      # 用户去认证
      session.delete(:openid)
      redirect_to_authorize_url($client)
    end
  end

  def redirect_to_authorize_url(client, scope = "snsapi_userinfo", state = "weixin")
    begin
      redirect_to client.authorize_url(code_weixin_users_url, scope, state) and return
    rescue Exception => e
      @wu ||= WeixinUser.find_by(openid: session[:openid])
      redirect_to session.delete(:back_link)
    end
  end

  def next_redirect(wu)
      openids = wu.weixin_openids.to_a.map(&:apid)
      redirect_to session.delete(:back_link) and return if wu.blank?
      if openids.count > 2
        wu.post_info(session.delete(:user_token))
        redirect_to session.delete(:back_link)
      else
        if openids.include?(1)
          redirect_to_authorize_url($client2, "snsapi_base", "2A#{wu.id}")
        else
          redirect_to_authorize_url($client1, "snsapi_base", "1A#{wu.id}")
        end
      end
  end


end
