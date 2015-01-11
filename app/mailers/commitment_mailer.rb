class CommitmentMailer < ApplicationMailer
  add_template_helper(CommitmentsHelper)

  def notify_today(date = Date.today)
    @date = date
    @commitments =
      Commitment.includes(:user).where(date: @date, users: { suspended: false })

    if @commitments.any?
      subject = "#{pluralize @commitments.count, 'National'} Today"
    else
      subject = 'No Nationals Today'

      # get a random quote
      quote_url =
        'http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en'
      @quote = JSON.parse(HTTParty.get(quote_url).body).with_indifferent_access
    end

    recipients = [User.find_by_email('rossdakin@gmail.com')]
    recipients.each do |user|
      @user = user
      email_with_name = %("#{@user.name}" <#{@user.email}>)
      mail(to: email_with_name, subject: subject)
    end
  end
end
