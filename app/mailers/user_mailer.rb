class UserMailer < ApplicationMailer

    def send_parsed_file
        @user = params[:user]
        attachments[@user.parsed_file_file_name] = File.read(@user.parsed_file.path)
        mail(to: @user.email, subject: 'Parsed Excel File')
    end
end
