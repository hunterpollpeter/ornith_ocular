class AddUserIdToSitings < ActiveRecord::Migration[5.1]
  def change
    add_column :sitings, :user_id, :integer
  end
end
