

require 'httparty'

SCHEDULER.every '2m', :first_in => 0 do
  response = HTTParty.get("https://api.9292.nl/0.1/locations/utrecht/bushalte-botanische-tuinen/departure-times?lang=en-GB")


  departures = response["tabs"][0]["departures"]

	send_event('busstop', {items: departures.take(8)})
end