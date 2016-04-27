# send iplirconf
every 1.day, :at => '4:00 am' do
  wd = "~/hw_tools"
  ruby = `which ruby`
  command "cd #{wd}; #{ruby} ./send_all.rb >/dev/null 2>&1"
end
