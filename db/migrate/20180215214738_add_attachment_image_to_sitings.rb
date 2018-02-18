class AddAttachmentImageToSitings < ActiveRecord::Migration[5.1]
  def self.up
    change_table :sitings do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :sitings, :image
  end
end
