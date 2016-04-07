# send iplirconf
every 1.hour do
  wd = "/home/user/vipnet_hw_tools_ruby_dev"
  ruby = "/usr/bin/ruby"
  command "cd #{wd}; #{ruby} ./send_all.rb >/dev/null 2>&1"
end
