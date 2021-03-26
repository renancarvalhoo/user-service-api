class AccountKeyServiceJob
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(id)
    user = User.find(id)
    response = AccountKeyServiceClient.new('post', '/v1/account', { email: user.email, key: user.key }).request
    user.update_attribute(:account_key, response['account_key']) if response
  end
end
