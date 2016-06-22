every 1.day, :at => '2am' do
  wd = "~/config"
  rake = `which rake`
  command "cd #{wd}; #{rake} send_all_iplirconfs >/dev/null 2>&1"
end

every 1.day, :at => "6am" do
  wd = "~/config"
  rake = `which rake`
  command "cd #{wd}; rake send_last_n_tickets >/dev/null 2>&1"
end

every :sunday, :at => "8am" do
  wd = "~/config"
  rake = `which rake`
  command "cd #{wd}; rake send_all_tickets >/dev/null 2>&1"
end
