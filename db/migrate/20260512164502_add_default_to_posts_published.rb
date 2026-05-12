class AddDefaultToPostsPublished < ActiveRecord::Migration[8.1]
  def change
    change_column_default :posts, :published, from: nil, to: false
    reversible do |dir|
      dir.up { Post.where(published: nil).update_all(published: false) }
    end
  end
end
