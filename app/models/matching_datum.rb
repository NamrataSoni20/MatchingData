require 'spreadsheet'
class MatchingDatum < ApplicationRecord
    has_attached_file :file
    has_attached_file :parsed_file
    validates_attachment_file_name :file, matches: [/\.xlsx?$/]
    validates_attachment_presence :file
    validates_attachment_file_name :parsed_file, matches: [/\.xlsx?$/]
    validates :email, presence: true, format: { with: /(\A([a-z]*\s*)*\<*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\>*\Z)/i }

    after_create :send_file

    def send_file
        self.delay.insert_in_delayed_queue(self)
    end 

    def save_file(obj, path)
        File.open("ParsedExcelFile#{obj.id}.xls") do |f| 
            obj.parsed_file = f
            obj.save 
        end 
        File.delete(path) if File.exist?(path) #deleted local file
    end 
    def send_mail_user(obj)
        UserMailer.with(user: obj).send_parsed_file.deliver_now
    end 

    def insert_in_delayed_queue(obj)
        workbook = Spreadsheet.open(obj.file.path)
        worksheets = workbook.worksheets
        
        #store parsed data start
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet(name: 'ParsedExcelFile')
        #store parsed data ends

        worksheets.each do |worksheet|
            num_rows = 0
            worksheet.rows.each do |row|
              data = MatchingDatum.get_data_from(row[1])
              matched = MatchingDatum.match_url(row[0], data)
              matched = get_label(matched)
              sheet.row(num_rows).push(row[0], row[1], matched)
              num_rows +=1
            end
            book.write "ParsedExcelFile#{obj.id}.xls"
            save_file(obj, "ParsedExcelFile#{obj.id}.xls")
            send_mail_user(obj)  
        end
    end 

    def get_label(value)
        if value
           return "Url Matched"
        else 
           return "Url does not matched"
        end 
    end
    
    class << self
        def get_data_from(data_url)
            response = HTTParty.get(data_url)
        end 

        def match_url(url, data)
            matched = data.include?(url)
            return matched
        end 
    end 
end
