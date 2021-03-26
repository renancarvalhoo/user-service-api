require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test_validates_presence_of :email, :phone_number, :password, :key

  test_validates_uniqueness_of User.find_by(email: 'robinwilliams@email.com'), :email, :phone_number, :account_key, :key

  test 'valid user' do
    user = User.new(
      email: 'robert@email.com',
      phone_number: '+5512991910011',
      full_name: 'Robert Hanks',
      password: 'foobar',
      metadata: 'actor united states',
      key: SecureRandom.base64,
    )
    assert user.valid?
  end

  test 'generate key is working' do
    user = User.new(
      email: 'tom@email.com',
      phone_number: '+5512991910013',
      full_name: 'Tom Hanks',
      key: SecureRandom.base64,
      password: 'foobar',
      metadata: 'actor united states'
    )
    assert user.valid?
    assert user.password_digest
  end

  test 'is possible to search by email, full_name, and metadata' do
    assert User.search_by('willsmith@email.com').any?
    assert User.search_by('male 32 actor eua').any?
    assert User.search_by('Will Smith').any?
    assert User.search_by('mickey').empty?
  end

  test 'validates email format' do
    user = User.new(
      email: 'wrong email',
      phone_number: '+5512991910013',
      full_name: 'Tom Hanks',
      key: SecureRandom.base64,
      password: 'foobar',
      metadata: 'actor united states'
    )

    refute user.valid?
    assert user.errors.messages[:email].include?('is invalid')
  end

  test 'most recently users search' do
    assert_equal User.recents, User.order(created_at: :desc)
  end
end
