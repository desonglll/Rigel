class AddAuthorToPosts < ActiveRecord::Migration[8.1]
  def change
    change_table :posts do |t|
      add_reference :posts, :author, null: false, foreign_key: { to_table: :users }
    end
  end
end
