desc 'run jasmine specs'
task :jasmine, :environment do
  `bundle exec guard-jasmine --server_timeout 180`
end

desc 'send score reports'
task :send_score_reports => :environment do
  User.find_in_batches do |users|
    users.each do |user|
      ScoreReportMailer.summary(user.id).deliver
    end
  end
end

task(:default).enhance ['jasmine']
