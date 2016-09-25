class QrcodesController < ApplicationController
  before_action :require_login
  
  def index
  	@qrcodes = Qrcode.all
  end

  def new
  	@qrcode = Qrcode.new
  end

  def create
  	scene = params[:qrcode][:scene].to_s
  	@qrcode = Qrcode.new
  	flash[:notice] = "请检查参数"
  	render :new and return if scene.length > 64 || scene.length == 0
  	result = $client.create_qr_limit_str_scene({scene_str: scene})
  	render :new and return if result.en_msg != "ok"
  	Qrcode.create({ticket: result.result["ticket"], url: result.result["url"], scene: scene, weixin_id: 0})
  	redirect_to qrcodes_url, flash: {notice: "创建成功"}
  end

end
