module CommandLineInterface

  def self.greet
    welcome_art = Artii::Base.new
    puts welcome_art.asciify("The Commuter")
    puts "------------------"
  end

  def self.basic_login_and_run
    puts "Please sign-in with your username."
    response = prompt.ask("What is your username?", default: ENV['USER'])
    exit if response.downcase == "exit"

    @current_user = User.find_by(name: response) if User.find_by(name: response)
    if @current_user == nil
        sign_up
    end
    run_program
  end

  def self.sign_up
    puts "Please create your username."
    name_response = prompt.ask("Username?", default: ENV['USER'])
    pass_response = prompt.mask("Password?")
    @current_user = User.create(name: name_response, password: pass_response)
    run_program
  end

  def self.prompt
      @prompt = TTY::Prompt.new
  end

  def self.parse_trainall_list
    TrainStation.all.map do |ts_obj|
      id_string, name = ts_obj[:id].to_s, ts_obj[:name]
      stop_id, route_id = ts_obj[:stop_id], ts_obj[:route_id]

      "#{id_string}--#{name}--#{stop_id}--#{route_id}"
    end
  end

  def self.show_fav_list
    @current_user.favorite_stations.map do |fs_obj|
      id_string, name = fs_obj.train_station[:id].to_s, fs_obj.train_station[:name]
      stop_id, route_id = fs_obj.train_station[:stop_id], fs_obj.train_station[:route_id]

      "#{id_string}--#{name}--#{stop_id}--#{route_id}"
    end
  end



  def self.depart
    selected_fav = prompt.select("Choose", show_fav_list, filter: true)
    choice_id = selected_fav.split("--").first.to_i
    route_ids = selected_fav.split("--").last
    stop_id = selected_fav.split("--").third

    n_or_s = prompt.select("Northbound or Southbound", %w(N S))

    runner = MtaRunner.new
    api_url = runner.parseurl_by_route_id(route_ids)
    data = runner.fetch_livefeed(api_url)

    current_departure_epoch = runner.station_time(data, stop_id, n_or_s)
    current_departure_times = current_departure_epoch.map { |time| Time.at(time).to_s }

    puts "Upcoming train departures...\n"
    next_three_departure_times = current_departure_times[0..2].join("\n")
    output_to_user = next_three_departure_times.length > 0 ? next_three_departure_times : "Times not available; please check back later."
    puts "#{output_to_user}"
    run_program
  end

  def self.add_to_favorites
    options = parse_trainall_list

    station_to_add = prompt.select("What do you want to add?", options, filter: true)
    station_to_add_pid = station_to_add.split("--").first.to_i
    FavoriteStation.create(user: @current_user, train_station: TrainStation.find(station_to_add_pid))
    run_program
  end

  def self.del_from_favorites
    selected_fav = prompt.select("Choose", show_fav_list, filter: true)
    station_to_del_pid = selected_fav.split("--").first.to_i
    confirm_del = prompt.yes?("Are you sure you want to delete #{selected_fav[2]} station?")
    if confirm_del
      @current_user.favorite_stations.find_by(train_station_id: station_to_del_pid).destroy
    else
      puts "------------------"
      puts "Let's start from the beginning, shall we?"
      run_program
    end
  end

  def self.update_selected_favorite
    station_to_replace = prompt.select("Choose", show_fav_list, filter: true)
    station_to_replace_pid = station_to_replace.split("--").first.to_i
    options = parse_trainall_list
    station_to_add = prompt.select("What do you want to add?", options, filter: true)
    station_to_add_pid = station_to_add.split("--").first.to_i
    @current_user.favorite_stations.where(user_id: @current_user.id, train_station_id: station_to_replace_pid).update(train_station_id: station_to_add_pid)
    run_program
  end

  def self.help
    puts "I accept the following commands:"
    puts "- depart  : displays upcoming departures times from your selected favorite station"
    puts "- add     : adds a train station to your favorites"
    puts "- update  : replaces a selected favorite station with a new station"
    puts "- delete  : removes a train station from your favorites list"
    puts "- exit    : exits this program"
  end

  def self.exit_program
    puts "Goodbye! Wishing you a nice commute!"
    exit
  end

  def self.run_program
    puts "------------------"
    @current_user = User.find(@current_user.id) if User.find(@current_user.id)

    choices = %w(depart add update delete help exit)
    input = prompt.select("Please enter a command", choices)

    while input != "exit"
      if input == "help"
        help
        run_program
      elsif input == "delete"
        del_from_favorites if @current_user.favorite_stations != []
        puts "Please add a station to enable this feature; you currently have 0 saved."
        run_program
      elsif input == "add"
        add_to_favorites
        run_program
      elsif input == "update"
        update_selected_favorite if @current_user.favorite_stations != []
        puts "Please add a station to enable this feature; you currently have 0 saved."
        run_program
      elsif input == "depart"
        depart if @current_user.favorite_stations != []
        puts "Please add a station to enable this feature; you currently have 0 saved."
        run_program
      else
        puts "Invalid input, please try again."
        help
        run_program
      end # ifs: cli controls
    end # while: break when 'exit'
    exit_program
  end
end
