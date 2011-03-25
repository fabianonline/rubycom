class Notifications < ActionMailer::Base
  

  def errors(errored_comics, sent_at = Time.now)
    subject    'Probleme beim Comic-Update'
    recipients 'mail@fabianonline.de'
    from       'rubycom@fabianonline.de'
    sent_on    sent_at
    body       :comics => errored_comics
  end

end
