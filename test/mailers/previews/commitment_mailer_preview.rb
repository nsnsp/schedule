# Preview all emails at http://localhost:3000/rails/mailers/commitment_mailer
class CommitmentMailerPreview < ActionMailer::Preview
  def notify_today_preview
    CommitmentMailer.notify_today
  end
end
