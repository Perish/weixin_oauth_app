class WeixinController < ApplicationController
	protect_from_forgery except: [:receive, :auth]
	def receive
		if request.get?
			tempArr = [params[:timestamp], params[:nonce], "dslf"].sort.join()
			if params[:signature] == Digest::SHA1.hexdigest(tempArr)
				Rails.logger.info "signature"
				render text: params[:echostr]
			else
				render text: ""
			end
		else
			ActionController::Parameters.permit_all_parameters = true
			unsafe_params = params.to_unsafe_h
			Rails.logger.info "unsafe_params==========#{unsafe_params.inspect}"
			render text: ""
		end
	end


	def set_client
		
	end
end