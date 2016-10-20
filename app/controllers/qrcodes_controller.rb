class QrcodesController < ApplicationController
  before_action :require_login

  
  def index
    @qrcodes = if params[:search].blank?
  	             Qrcode.page(params[:page]).per(50)
               else
                 Qrcode.where("scene like ?", "%#{params[:search]}%").page(params[:page]).per(50)
               end
  end

  def download
    if params[:id].present?
      zip_url = Qrcode.zip_qrcode(params[:id])
      zip_data = File.read(zip_url)
      send_data(zip_data, :type => 'application/zip', :filename => "archive.zip") 
      FileUtils.rm zip_url
      return 
    end
   redirect_to qrcodes_url
  end

  def attach
    
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
    # 创建二维码
    notice = Qrcode.deal_with(ss)
    redirect_to qrcodes_url, flash: {notice: notice}
  end

end
