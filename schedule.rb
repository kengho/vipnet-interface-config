# send iplirconf
every 1.hour do
  wd = "~/hw_tools"
  ruby = `which ruby`
  command "cd #{wd}; #{ruby} ./send_all.rb >/dev/null 2>&1"
end
