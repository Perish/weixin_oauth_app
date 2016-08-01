class LinksController < ApplicationController
  before_action :require_login

  # GET /links
  # GET /links.json
  def index
    @link = current_user.link || current_user.build_link
  end

  # POST /links
  # POST /links.json
  def create
    @link = current_user.build_link(link_params)
    respond_to do |format|
      if @link.save
        format.html { redirect_to links_path, notice: '接口创建成功' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    @link = current_user.link
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to links_path, notice: '接口更新成功' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:link, :status)
    end
end
