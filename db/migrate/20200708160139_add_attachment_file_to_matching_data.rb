class AddAttachmentFileToMatchingData < ActiveRecord::Migration[5.2]
  def self.up
    change_table :matching_data do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :matching_data, :file
  end
end
