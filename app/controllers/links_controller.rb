class LinksController < ApplicationController
  before_action :require_login

  # GET /links
  # GET /links.json
  def index
    @links = current_user.links
  end

  def new
    @link = current_user.links.new
  end

  def edit
    @link = current_user.links.find(params[:id])
  end

  # POST /links
  # POST /links.json
  def create
    link_types = current_user.links.map(&:link_type)
    link_type_params = link_params["link_type"].to_i
    @link = current_user.links.new(link_params)
    respond_to do |format|
      if !link_types.include?(link_type_params) && @link.save
        format.html { redirect_to links_path, notice: '接口创建成功' }
        format.json { render :show, status: :created, location: @link }
      else
        flash[:notice] = "只能创建一个生产或者测试链接"
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    link_types = current_user.links.map(&:link_type)
    link_type_params = link_params["link_type"].to_i
    @link = current_user.links.find(params[:id])
    link_types.delete(@link.link_type)
    respond_to do |format|
      if !link_types.include?(link_type_params) && @link.update(link_params)
        format.html { redirect_to links_path, notice: '接口更新成功' }
        format.json { render :show, status: :ok, location: @link }
      else
        flash[:notice] = "只能拥有一个生产或者测试链接"
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @link = current_user.links.find(params[:id])
    @link.destroy
    redirect_to links_path
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:link, :status, :link_type)
    end
end
