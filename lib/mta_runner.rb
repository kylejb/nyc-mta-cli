require 'protobuf'
require 'google/transit/gtfs-realtime.pb'
require 'httparty'
require 'dotenv'
require 'pry'

Dotenv.load

class MtaRunner

    def parseurl_by_route_id(route_ids)
        routeid_arr = route_ids.split(" ")

        routeid_arr.each do |parse_route_id|
            if "BDFM".include?(parse_route_id)
                return(trainlines_BDFM)
            
            elsif "ACE".include?(parse_route_id)
                return(trainlines_ACE)
            
            elsif "G".include?(parse_route_id)
                return(trainlines_G)
            
            elsif "JZ".include?(parse_route_id)
                return(trainlines_JZ)
            
            elsif "L".include?(parse_route_id)
                return(trainlines_L)
            
            elsif "NQRW".include?(parse_route_id)
                return(trainlines_NQRW)
            
            elsif "123456".include?(parse_route_id)
                return(trainlines_123456)
            
            elsif "7".include?(parse_route_id)
                return(trainlines_7)
            
            elsif "SI".include?(parse_route_id)
                return(trainlines_SI)
            
            end
        end
    end

    def trainlines_BDFM
        @url_bdfm = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-bdfm"
    end

    def trainlines_ACE
        @url_ace = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-ace"
    end

    def trainlines_G
        @url_g = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-g"
    end

    def trainlines_JZ
        @url_jz = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-jz"
    end

    def trainlines_L
        @url_l = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-l"
    end

    def trainlines_NQRW
        @url_nqrw = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-nqrw"
    end

    def trainlines_123456
        @url_123456 = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs"
    end

    def trainlines_7
        @url_7 = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-7"
    end

    def trainlines_SI
        @url_si = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs-si"
    end

    def train_alerts
        @url_alerts = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/camsys%2Fsubway-alerts"
    end

    def fetch_livefeed(api_url)
        data = HTTParty.get(api_url, headers: {"x-api-key" => ENV["MTA_KEY"]})
        feed = Transit_realtime::FeedMessage.decode(data)
        return feed.entity
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


