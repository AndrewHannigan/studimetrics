desc 'run jasmine specs'
task :jasmine, :environment do
  `bundle exec guard-jasmine --server_timeout 180`
end

desc 'send score reports'
task :send_score_reports => :environment do
  User.where(active: true).find_in_batches do |users|
    users.each do |user|
      #ScoreReportMailer.summary(user.id).deliver
    end
  end
end

desc 'send summary on Sunday only'
task :send_score_reports_on_time => :environment do
  if Time.now.utc.sunday?
    #Rake::Task[:send_score_reports].invoke
  end
end

task(:default).enhance ['jasmine']
