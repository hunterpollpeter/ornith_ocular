class AddAttachmentStaticMapToSitings < ActiveRecord::Migration[5.1]
  def self.up
    change_table :sitings do |t|
      t.attachment :static_map
    end
  end

  def self.down
    remove_attachment :sitings, :static_map
  end
end
