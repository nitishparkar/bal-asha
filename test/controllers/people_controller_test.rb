class PeopleControllerTest < ActionController::TestCase

  def setup
    sign_in people(:nitish)
  end

  test "only admins should be able to access this section" do
    sign_out :person
    sign_in people(:staff)
    get :index
    assert_redirected_to root_path

    sign_out :person
    sign_in people(:volunteer)
    get :index
    assert_redirected_to root_path
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
  end

end
