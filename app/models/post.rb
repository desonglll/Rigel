class Post < ApplicationRecord
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_rich_text :content

  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }

  validates :title, presence: true
  paginates_per 10
end
