class AddColumnLocationToSitings < ActiveRecord::Migration[5.1]
  def change
    add_column :sitings, :location, :string
  end
end
