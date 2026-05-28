class Owner < ApplicationRecord
    has_many :pets, dependent: :destroy
    belongs_to :user, optional: true

    before_validation :normalize_email

    validates :first_name, :last_name, :phone, presence: true
    validates :email, presence: true, 
                    uniqueness: true, 
                    format: { with: URI::MailTo::EMAIL_REGEXP }

    

    def normalize_email
        self.email = email.to_s.strip.downcase
    end

    def name
        "#{first_name} #{last_name}"
    end
    private
end
