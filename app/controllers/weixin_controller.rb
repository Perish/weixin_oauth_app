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
			Rails.logger.info "unsafe_params==========#{params.inspect}"
			render text: ""
		end
	end

	def set_client
		
	end
end