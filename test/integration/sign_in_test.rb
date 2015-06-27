require "test_helper"

class SignInTest < ActionDispatch::IntegrationTest

  test "login and logout" do
    get new_person_session_path
    assert_response :success
    post_via_redirect person_session_path, "person[email]" => people(:nitish).email, "person[password]" => "password"
    assert_response :success
    assert_equal root_path, path

    delete_via_redirect destroy_person_session_path
    assert_response :success
    assert_equal new_person_session_path, path
  end

end
