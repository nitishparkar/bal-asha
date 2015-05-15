require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  test "email is mandatory" do
    person = Person.new(password: "tA98R0g71ET")
    assert_not person.save
  end

  test "password is mandatory" do
    person = Person.new(email: "johndoe@genii.in")
    assert_not person.save
  end

  test "only email and password are mandatory" do
    person = Person.new(email: "johndoe@genii.in", password: "tA98R0g71ET")
    assert person.save
  end

  test "email should be unique" do
    Person.create(email: "johndoe@genii.in", password: "tA98R0g71ET")
    person = Person.new(email: "johndoe@genii.in", password: "tA98R0g71ET")
    assert_not person.save
  end

  test "default type should not be admin" do
    person = Person.new
    assert_not person.admin?
  end

end
