require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "generate key works" do
    user = User.new(
      email: 'tom@email.com',
      phone_number: '+5512991910011',
      full_name: 'Tom Hanks',
      password: 'foobar',
      metadata: 'actor united states'
    )

    assert(user.save)
    assert user.password_digest
  end
end
