class Membership < ApplicationRecord
  belongs_to :user

  enum :role, {
    patient: 0,
    doctor: 1,
    admin: 2
  }

  validates :clinic_id, presence: true
  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :clinic_id }
end