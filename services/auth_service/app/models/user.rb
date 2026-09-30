class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :memberships, dependent: :destroy

  validates :name, presence: true

   enum :platform_role, {
    user: 0,
    admin: 1
  }
end