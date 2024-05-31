task :release
task :server => [:swapfile, 'db:migrate'] do
  sh 'console -C "/rails/bin/rails db:migrate"'
end
