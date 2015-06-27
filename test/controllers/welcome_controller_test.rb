class WelcomeControllerTest < ActionController::TestCase

  def setup
    sign_in people(:nitish)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:donors)
    assert_not_nil assigns(:needs)
    assert_not_nil assigns(:call_for_actions)
  end

end
