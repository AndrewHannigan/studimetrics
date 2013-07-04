desc 'run jasmine specs'
task :jasmine, :environment do
  `bundle exec guard-jasmine --server_timeout 180`
end

task(:default).enhance ['jasmine']
