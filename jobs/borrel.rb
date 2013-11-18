#!/usr/bin/env ruby
require 'open-uri'
require 'nokogiri'
require 'date'
require 'cgi'

# Config
# make sure your URLs end with /full, not /simple (which is default)!
# ------
calendars = [name:'Borrel', url:'https://www.google.com/calendar/feeds/tvh5m74l58o1pf508k7038ousc%40group.calendar.google.com/public/full' ]
events = Array.new

SCHEDULER.every '10m', :first_in => 0 do |job|
	events = Array.new
	min = CGI.escape(DateTime.now().to_s)
	max = CGI.escape((DateTime.now()+7).to_s)
	
	calendars.each do |calendar|
		url = calendar[:url]+"?singleevents=true&orderby=starttime&start-min=#{min}&start-max=#{max}"
		reader = Nokogiri::XML(open(url))
		reader.remove_namespaces!
		reader.xpath("//feed/entry").each do |e|
			title = e.at_xpath("./title").text
			when_node = e.at_xpath("./when")
			if when_node
				start_time = DateTime.iso8601(when_node.attribute('startTime').text)
				end_time = DateTime.iso8601(when_node.attribute('endTime').text)

				events.push({title: title,
					        when_start_raw: start_time.to_time.to_i,
					        when_end_raw: end_time.to_time.to_i,
					        when_start: start_time,
					        when_end: end_time})
			end
		end
	end
	events.select! { |e| e[:title] =~ /borrel/i }
	events.sort! { |a,b| a[:when_start_raw] <=> b[:when_start_raw] }
	events = events.slice!(0,15) # 15 elements is probably enough...
	

	send_event('borrel_events', events[0])
end

SCHEDULER.every '1m', :first_in => 0 do |job|
	events_tmp = Array.new(events)
	events_tmp.delete_if{|event| DateTime.now().to_time.to_i>=event[:when_start_raw]}
	
		
	if events_tmp.count != events.count
		events = events_tmp
		send_event('borrel_events', events[0])
	end
end