class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  has_rich_text :body

  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  def root?
    parent_id.nil?
  end

  validates :depth, inclusion: { in: 0..3 }

  scope :root_comments, -> { where(parent_id: nil) }
  scope :ordered, -> { order(created_at: :asc) }

  before_validation :set_depth

  def set_depth
    self.depth = parent ? parent.depth + 1 : 0
  end
end
