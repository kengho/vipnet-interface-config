require "me_sd"
require "vipnet_parser"
require "vipnet_getter"
require "yaml"
require "net/http"
require "rest_client"

NET_EXCEPTIONS = [Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::EHOSTUNREACH, EOFError,
  Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError]

task :send_last_n_tickets do
  settings = YAML.load_file("tickets.yml")
  sd = prepare_sd(settings)
  if sd.last_error
    print sd.last_error
  else
    last_n_tickets = sd.get_last_requests(settings["last_tickets_number"])
    send_tickets({ tickets: last_n_tickets, settings: settings })
  end
end

task :send_all_tickets do
  settings = YAML.load_file("tickets.yml")
  sd = prepare_sd(settings)
  if sd.last_error
    print sd.last_error
  else
    all_tickets = sd.get_all_requests
    send_tickets({ tickets: all_tickets, settings: settings })
  end
end

task :send_all_iplirconfs do
  data = YAML.load_file("getter.yml")
  data["coordinators"].each do |coordinator|
    iplirconf_file = VipnetGetter::iplirconf({
      hostname: coordinator["hostname"],
      password: coordinator["password"],
    })
    RestClient.post(
      data["iplirconfs_api_url"],
      # payload
      {
        vipnet_id: coordinator["vipnet_id"],
        content: File.new(iplirconf_file, "rb"),
      },
      # headers
      {
        Authorization: "Token token=#{data['iplirconfs_api_token']}",
      },
    )
  end
end

def prepare_sd(settings)
  sd = MESD.new({
    host: settings["host"],
    port: settings["port"],
    username: settings["username"],
    password: settings["password"],
  })
  sd
end

def send_tickets(args)
  args[:tickets].each do |ticket|
    ticket_data = ticket.data(:name, :description, :resolution)
    vipnet_ids = VipnetParser::id({
      string: ticket_data.name + ticket_data.description + ticket_data.resolution,
      threshold: "0xffff".to_i(16),
    })
    vipnet_ids.each do |vipnet_id|
      uri = URI("http://#{args[:settings]['api_url']}")
      begin
        Net::HTTP.start(uri.host, uri.port) do |http|
          data = { ticket: { vipnet_id: vipnet_id, id: ticket.id, url_template: args[:settings]["ticket_url_template"] }}
          headers = { "Authorization" => "Token token=#{args[:settings]['api_token']}" }
          request = http.post(uri, URI.encode_www_form(data), headers)
          print request.response.body
        end
      rescue *NET_EXCEPTIONS => e
      end
    end
  end
end
