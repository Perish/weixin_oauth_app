# coding: utf-8
class HomeController < ApplicationController
  def index
  	client = WeixinAuthorize::Client.new("wx2c05d384bb5858fe", "466acf45848719268e69363525e4e02a")
  	@followers = client.user("oF4pBsyIO_P2o6skNefruQASfFFs")
  end
end
