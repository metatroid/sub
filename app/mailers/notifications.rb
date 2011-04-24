class Notifications < ActionMailer::Base
  def contactme(email_params, sent_at = Time.now)
    subject "Electronic Mail: " << email_params[:subject]
    recipients "science@metatroid.com" 
    from email_params[:address]
    sent_on sent_at

    body :message => email_params[:body], :sender_name => email_params[:name]
  end

end
