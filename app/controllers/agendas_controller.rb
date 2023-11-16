class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  def destroy
  #アジェンダの作者か、紐づいているチームのリーダのみ削除できる
    @agenda = Agenda.find(params[:id])
    @team_owner_id = Team.find(@agenda.team_id).owner_id
    if @agenda.user_id == current_user.id || @team_owner_id == current_user.id
      @agenda.destroy
      AgendaMailer.agenda_destroy_mail(@agenda).deliver
      redirect_to dashboard_path, notice: I18n.t('views.messages.delete_agenda')
    else
      redirect_to dashboard_path, notice: I18n.t('views.messages.failed_to_delete_agenda')
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
