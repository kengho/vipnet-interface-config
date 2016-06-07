# send iplirconf
every 1.day, :at => '4am' do
  wd = "~/hw_tools"
  ruby = `which ruby`
  command "cd #{wd}; #{ruby} ./send_all.rb >/dev/null 2>&1"
end

every 1.day, :at => "6am" do
  wd = "~/config"
  command "cd #{wd}; rake send_last_n_tickets >/dev/null 2>&1"
end

every :sunday, :at => "8am" do
  wd = "~/config"
  command "cd #{wd}; rake send_all_tickets >/dev/null 2>&1"
end
