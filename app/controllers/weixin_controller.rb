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

	def gota
		url = case params[:id].to_i
			when 1 then "http://mp.weixin.qq.com/s?__biz=MzAwNzQxNjg1NQ==&tempkey=ttTYmlE2QzEDwKtiae52egbwX7e2nu%2FhXYn9TWkvlr20qdtsnz%2BwehezG1RKgQqDJbtRz%2Fh3axNOxt4ai4C7zGtaz%2FhqD7Y8H87gcbXX4NgHyFCFbDUibPnNlrZDxQAcyKDjoRNRlscXjglvhBTPcw%3D%3D&#rd"
			when 2 then "http://mp.weixin.qq.com/s?__biz=MzAwNzQxNjg1NQ==&tempkey=ttTYmlE2QzEDwKtiae52egbwX7e2nu%2FhXYn9TWkvlr0TpBOuCofzSw%2FVMdcQVB%2Fsget2rln%2FE7aXNg0hkZsmJBhvDQ1u13MBWs4wC%2BHW8acHyFCFbDUibPnNlrZDxQAcR1ihSniEw3Mc9%2BSlWYiFzg%3D%3D&#rd"
			when 3 then "http://www.cwrcpj.org/_client/goToAuth?redirectUrl=http://www.cwrcpj.org:8051/personalInfor.html"
			when 4 then "http://www.cwrcpj.org/_client/goToAuth?redirectUrl=http://www.cwrcpj.org:8051/applyEvaluate.html"
			end
		redirect_to url
	end


	def set_client
		
	end
end