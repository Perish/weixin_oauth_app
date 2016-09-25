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
		@client = case params[:id].to_i
					when 0 then $client
					when 1 then $client1
					when 2 then $client2
	end
end