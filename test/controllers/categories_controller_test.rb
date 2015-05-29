class CategoriesControllerTest < ActionController::TestCase

  def setup
    sign_in people(:nitish)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:categories)
  end


end
