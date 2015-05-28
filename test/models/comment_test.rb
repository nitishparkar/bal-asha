require "test_helper"

class CommentTest < ActiveSupport::TestCase

  test "person is mandatory" do
    comment = comments(:comment1)
    comment.person = nil
    assert_not comment.save
  end

  test "content is mandatory" do
    comment = comments(:comment1)
    comment.content = nil
    assert_not comment.save
  end

  test "commentable is mandatory" do
    comment = comments(:comment1)
    comment.commentable = nil
    assert_not comment.save
  end

  test "should delegate email to person" do
    assert_not_empty comments(:comment1).person_email
  end

end
