require "me_sd"
require "vipnet_parser"
require "yaml"
require "net/http"

EXCEPTIONS = [Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::EHOSTUNREACH, EOFError,
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
    vipnet_ids = VipnetParser::id(ticket_data.name + ticket_data.description + ticket_data.resolution)
    vipnet_ids.each do |vipnet_id|
      uri = URI("http://#{args[:settings]['api_url']}")
      begin
        Net::HTTP.start(uri.host, uri.port) do |http|
          data = { ticket: { vipnet_id: vipnet_id, id: ticket.id, url_template: args[:settings]["ticket_url_template"] }}
          headers = { "Authorization" => "Token token=#{args[:settings]['token']}" }
          request = http.post(uri, URI.encode_www_form(data), headers)
          print request.response.body
        end
      rescue *EXCEPTIONS => e
      end
    end
  end
end
