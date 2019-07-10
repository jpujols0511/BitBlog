require "action_mailer"
# set which directory ActionMailer should use

ActionMailer::Base.view_paths = File.dirname(__FILE__)

# ActionMailer configuration

ActionMailer::Base.smtp_settings = {

  address:    'smtp.gmail.com',

  port:       '587',

  user_name: ENV["bitblog_email"],

  password:   ENV["bitblog_password"],

  authentication: :plain

}

class Newsletters < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(recipient, confirmation, last_name)
    @recipient = recipient
    @confirmation = confirmation
    @last_name = last_name
    mail(to: recipient, subject: 'Welcome to BitBlog')
  end

end
