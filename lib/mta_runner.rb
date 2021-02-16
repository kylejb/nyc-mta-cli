require 'protobuf'
require 'google/transit/gtfs-realtime.pb'
require 'httparty'
require 'dotenv'
require 'pry'

Dotenv.load

class MtaRunner
  @url_alerts = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/camsys%2Fsubway-alerts"

  def parseurl_by_route_id(route_ids)
    mta_endpoint = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs"
    routeid_arr = route_ids.split(" ")

    routeid_arr.each do |parse_route_id|
      if "BDFM".include? parse_route_id
        return mta_endpoint + "-bdfm"

      elsif "ACE".include? parse_route_id
        return mta_endpoint + "-ace"

      elsif "G".include? parse_route_id
        return mta_endpoint + "-g"

      elsif "JZ".include? parse_route_id
        return mta_endpoint + "-jz"

      elsif "L".include? parse_route_id
        return mta_endpoint + "-l"

      elsif "NQRW".include? parse_route_id
        return mta_endpoint + "-nqrw"

      elsif "123456".include? parse_route_id
        return mta_endpoint

      elsif "7".include? parse_route_id
        return mta_endpoint + "-7"

      elsif "SI".include? parse_route_id
        return mta_endpoint + "-si"
      end
    end
  end

  def fetch_livefeed(api_url)
    data = HTTParty.get(api_url, headers: {"x-api-key" => ENV["MTA_KEY"]})
    feed = Transit_realtime::FeedMessage.decode(data)
    feed.entity
  end

  def station_time(data, stop_id, n_or_s)
    collected_times = []

    full_stop_id = stop_id + n_or_s

    for trains in data do
      # if !trains.dig(:trip_update, :stop_time_update).nil?
      if trains["trip_update"] != nil && trains["trip_update"]["stop_time_update"] != nil
        unique_train_schedule = trains["trip_update"]
        # scheduled_arrival = unique_arrival_times.filter {|time| time[:stop_id] == full_stop_id }
        unique_arrival_times = unique_train_schedule["stop_time_update"]
        for scheduled_arrivals in unique_arrival_times do
          if scheduled_arrivals["stop_id"] == full_stop_id
            time_data = scheduled_arrivals["arrival"]
            unique_time = time_data["time"]
            if unique_time
              collected_times.push(unique_time)
            end
          end
        end
      end
    end
    collected_times
  end
end


