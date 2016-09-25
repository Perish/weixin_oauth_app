class WeixinController < ApplicationController
	protect_from_forgery except: [:receive, :auth]
	def receive
		ActionController::Parameters.permit_all_parameters = true
		if params[:id].to_i == 1230 && params[:xml].present?
			case params[:xml][:Event]
			when "subscribe" then WeixinUser.deal_scan(params[:xml])
			end
		end
		render text: ""

	end

	def auth
		tempArr = [params[:timestamp], params[:nonce], "dslf"].sort.join()
		if params[:signature] == Digest::SHA1.hexdigest(tempArr)
			render text: params[:echostr]
		else
			render text: ""
		end
	end

end