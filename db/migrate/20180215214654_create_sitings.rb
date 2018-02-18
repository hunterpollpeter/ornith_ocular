class CreateSitings < ActiveRecord::Migration[5.1]
  def change
    create_table :sitings do |t|
      t.string :bird
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
