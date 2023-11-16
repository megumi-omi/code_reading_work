class AgendaMailer < ApplicationMailer
  default from: 'from@example.com'

  def agenda_destroy_mail(agenda)
    @agenda = agenda
    @team = Team.find(@agenda.team_id)
    mail to: @team.members.pluck(:email), subject: I18n.t('views.messages.new_team_owner')
  end
end
