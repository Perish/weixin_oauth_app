class WeixinController < ApplicationController
	def receive
		
	end

	def auth
		tempArr = [params[:timestamp], params[:nonce], "dslf"].sort.join()
		if params[:signature] == Digest::SHA1.hexdigest(tempArr)
			render text: params[:echostr]
		else
			render text: ""
		end
	end


	def set_client
		
	end
end