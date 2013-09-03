class ScoreReportEmailsController < ApplicationController

  def create
    @score_report_email = ScoreReportEmail.new current_user
    @score_report_email.add_recipient score_report_email_params[:score_report_email]
  end

  def destroy
    @score_report_email = ScoreReportEmail.new current_user
    @score_report_email.remove_recipient params[:score_report_email]
  end

  private

  def score_report_email_params
    params.permit(:score_report_email)
  end

end
