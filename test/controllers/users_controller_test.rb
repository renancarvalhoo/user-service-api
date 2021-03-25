require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get api_users_path
    assert_response :success
  end

  test 'should post create' do
    post api_users_path, params: {
      email: 'tom@email.com',
      phone_number: '+5512991910011',
      full_name: 'Tom Hanks',
      password: 'foobar',
      metadata: 'actor united states'
    }
    assert_response :success
  end
end
