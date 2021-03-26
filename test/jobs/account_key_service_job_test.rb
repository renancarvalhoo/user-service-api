require 'test_helper'

class AccountKeyServiceJobTest < ActiveSupport::TestCase

  def teardown
    Sidekiq::Worker.clear_all
  end

  def test_user_updated
    VCR.use_cassette("user_job") do
      Sidekiq::Testing.inline! do
        user = User.find_by(email: 'jimcarrey@email.com')
        refute user.account_key
        AccountKeyServiceJob.perform_async(user.id)
        user.reload
        assert user.account_key
      end
    end
  end
end