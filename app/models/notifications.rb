class Notifications < ActionMailer::Base
  def user_registered(recepient)
    recipients recepient.email
    from "system@mochar.com"
    subject "Thanks for registering in mochar!"
    body :user => recepient
  end

end
