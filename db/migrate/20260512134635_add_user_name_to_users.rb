class AddUserNameToUsers < ActiveRecord::Migration[8.1]
  def change
    change_table :users do |t|
      add_column :users, :user_name, :string
    end
  end
end
