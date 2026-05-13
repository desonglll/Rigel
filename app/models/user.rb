class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :user_name, presence: true, uniqueness: true
  has_many :posts, foreign_key: "author_id", dependent: :destroy
  before_create :generate_api_token

  private
  def generate_api_token
    self.api_token = SecureRandom.hex(24)
  end
end
