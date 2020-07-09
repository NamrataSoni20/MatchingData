class AddAttachmentParsedFileToMatchingData < ActiveRecord::Migration[5.2]
  def self.up
    change_table :matching_data do |t|
      t.attachment :parsed_file
    end
  end

  def self.down
    remove_attachment :matching_data, :parsed_file
  end
end
