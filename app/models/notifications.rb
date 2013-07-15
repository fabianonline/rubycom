# -*- encoding : utf-8 -*-
class Notifications < ActionMailer::Base
  

  def errors(errored_comics, sent_at = Time.now)
    subject    'Probleme beim Comic-Update'
    recipients AppConfig.admin_email
    from       AppConfig.self_email
    sent_on    sent_at
    body       :comics => errored_comics
  end

end
