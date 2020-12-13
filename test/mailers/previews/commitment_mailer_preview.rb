# Preview all emails at http://localhost:3000/rails/mailers/commitment_mailer
class CommitmentMailerPreview < ActionMailer::Preview
  def notify_day_preview
    CommitmentMailer.notify_day
  end
end
