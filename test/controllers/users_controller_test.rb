require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get api_users_path
    assert_equal 200, response.status
    assert User.count, JSON.parse(response.body)['users'].count
    assert_response :success
  end

  test 'should get index using parameter query' do
    get api_users_path, params: { query: 'robin williams actor'}
    assert_equal 200, response.status
    assert 1, JSON.parse(response.body)['users'].count
    assert_response :success
  end

  test 'should post create and check generated key by server side' do
    post api_users_path, params: {
      email: 'tom@email.com',
      phone_number: '+5512991910011',
      full_name: 'Tom Hanks',
      password: 'foobar',
      metadata: 'actor united states'
    }
    assert_response :success
    assert_equal 201, response.status
    response_user = JSON.parse(response.body)
    assert response_user['key']
    user = User.find_by(email: 'tom@email.com').as_json(only: %i[email phone_number full_name key account_key metadata])
    assert_equal user, response_user

  end

  test 'should returns an email error' do
    post api_users_path, params: {
      phone_number: '+5512991910011',
      full_name: 'Tom Hanks',
      password: 'foobar',
      metadata: 'actor united states'
    }
    assert_equal 422, response.status
    assert_equal ["Email can't be blank", "Email is invalid"], JSON.parse(response.body)['errors']
  end

  test 'should returns an error to non unique field' do
    post api_users_path, params: {
      email: 'jimcarrey@email.com',
      phone_number: '+5512991910011',
      full_name: 'Jim Carrey',
      password: 'foobar',
      metadata: 'actor united states'
    }
    assert_equal 422, response.status
    assert_equal ["Email has already been taken"], JSON.parse(response.body)['errors']
  end

  test 'should have created a password with salt value' do
    post api_users_path, params: {
      email: 'jerry@email.com',
      phone_number: '+5512991910123',
      full_name: 'Jerry Hanks',
      password: 'foobar',
      metadata: 'actor united states'
    }
    assert_response :success
    assert_equal 201, response.status
    response_user = JSON.parse(response.body)
    assert User.find_by(email: response_user['email']).password_digest
  end

  test 'should have updated with account key service data' do
    VCR.use_cassette("user_controller") do
      Sidekiq::Testing.inline! do
        post api_users_path, params: {
          email: 'tomas@email.com',
          phone_number: '+5512991910123',
          full_name: 'Tomas Hanks',
          password: 'foobar',
          metadata: 'actor united states'
        }
        assert_response :success
        assert_equal 201, response.status
        response_user = JSON.parse(response.body)
        assert User.find_by(email: response_user['email']).account_key
      end
    end
  end
end
