require "spec_helper"

describe ScoreReportMailer do
  describe "summary" do
    it "renders the headers" do
      user = create :user
      ScoreReport.any_instance.stubs(:percentile_in_words).returns('Above')

      mail = ScoreReportMailer.summary user

      expect(mail.subject).to eq I18n.t('score_reports.summary.subject')
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ["noreply@studimetrics.com"]
    end
  end
end
