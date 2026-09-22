class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :clinic

  enum :role, {
    patient: 0,
    doctor: 1,
    admin: 2
  }

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :clinic_id }
end