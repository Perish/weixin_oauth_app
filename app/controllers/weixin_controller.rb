class WeixinController < ApplicationController
	protect_from_forgery except: [:receive, :auth]
	def receive
		ActionController::Parameters.permit_all_parameters = true
		Rails.logger.info "params===========#{params.inspect}"
		Rails.logger.info "params==to_h=========#{params.to_h}"
		if params[:id].to_i = 1230 && params[:xml].present?
			case params[:xml][:Event]
			when "SCAN" then WeixinUser.deal_scan(params[:xml])
			end
		else
			render text: ""
		end
	end

	def auth
		tempArr = [params[:timestamp], params[:nonce], "dslf"].sort.join()
		if params[:signature] == Digest::SHA1.hexdigest(tempArr)
			render text: params[:echostr]
		else
			render text: ""
		end
	end

	def set_params
		params.require(:xml).permit(:ToUserName, :FromUserName, :CreateTime, :MsgType, :Event, :EventKey, :Ticket)
	end
end