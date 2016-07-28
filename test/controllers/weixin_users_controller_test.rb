require 'test_helper'

class WeixinUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get weixin_users_show_url
    assert_response :success
  end

end
