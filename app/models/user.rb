class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one :owner
  has_one :vet
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  enum :role, { owner: 0, vet: 1, admin: 2}

  validates :first_name, :last_name, presence: true
end
