class AddColumnAvatarUrlToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :avatar_url, :string
  end
end
