class CommitmentMailer < ApplicationMailer
  add_template_helper(CommitmentsHelper)
  TODAY = 'today'

  def notify_day(recipient, date = Date.today, day_description = TODAY)
    @user = recipient
    @date = date
    @day_description = day_description
    @commitments =
      Commitment.includes(:user).where(date: @date, users: { suspended: false })

    title_day_description = day_description == TODAY ? TODAY.titlecase : day_description

    if @commitments.any?
      subject = "#{pluralize @commitments.count, 'National'} #{title_day_description}"
    else
      subject = "No Nationals #{title_day_description}"

      # get a random quote
      quote_url =
        'http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en'
      @quote = JSON.parse(HTTParty.get(quote_url).body).with_indifferent_access
    end

    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: subject)
  end
end
