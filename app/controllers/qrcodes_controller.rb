class QrcodesController < ApplicationController
  before_action :require_login
  
  def index
    @qrcodes = if params[:search].blank?
  	             Qrcode.page(params[:page]).per(50)
               else
                 Qrcode.where("scene like ?", "%#{params[:search]}%").page(params[:page]).per(50)
               end
  end

  def new
  	@qrcode = Qrcode.new
  end

  def create
  	scene = params[:qrcode][:scene].to_s
  	@qrcode = Qrcode.new
    flash[:notice] = "不能为空"
    render :new and return if scene.blank?
    ss = scene.split(",").reject{|x| x.blank?}
    render :new and return if ss.blank?
    arr = []
    ss.each do |x|
    	result = $client.create_qr_limit_str_scene({scene_str: x.strip})
      if result.en_msg == "ok"
    	   Qrcode.create({ticket: result.result["ticket"], url: result.result["url"], scene: x.strip, weixin_id: 0})
      else
        arr << x.strip
      end
    end
    if arr.length > 0
      notice = "这些  #{arr.join(",")}  没有创建成功"
    else
      notice = "创建成功"
    end
  	redirect_to qrcodes_url, flash: {notice: notice}
  end

end
