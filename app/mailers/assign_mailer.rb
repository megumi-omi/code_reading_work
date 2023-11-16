class AssignMailer < ApplicationMailer
  default from: 'from@example.com'

  def assign_mail(email, password)
    @email = email
    @password = password
    mail to: @email, subject: I18n.t('views.messages.complete_registration')
  end

  def authority_transfer_mail(team)
    @team = team
    @email = User.find(@team.owner_id).email
    mail to: @email, subject: I18n.t('views.messages.new_team_owner')
  end
end