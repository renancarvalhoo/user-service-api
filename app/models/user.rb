class User < ApplicationRecord
  has_secure_password

  scope :search_by, ->(query) do
    where("email LIKE :query or full_name LIKE :query or metadata LIKE :query", query: query)
  end

  scope :recents, -> { order(created_at: :desc) }

  validates_uniqueness_of :email, :phone_number, :key
  validates_uniqueness_of :account_key, allow_nil: true

  validates_presence_of :email, :phone_number, :password, :key

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
end
