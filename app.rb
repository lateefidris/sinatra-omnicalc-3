require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "sinatra/cookies"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
end

get("/umbrella") do
  erb(:umbrella_form)
end


post("/process_umbrella")do
  @user_location = params.fetch("user_loc")
  user_location2 = @user_location.gsub(" ","+")
  key = ENV.fetch("GMAPS_KEY")

  gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location2}&key=#{key}"

  raw_response = HTTP.get(gmaps_url).to_s
  parsed_response = JSON.parse(raw_response)

  results = parsed_response.fetch("results").at(0)
  
  @formatted_address = results.fetch("formatted_address")

    geometry = results.fetch("geometry")
  location = geometry.fetch("location")
  @lat = location.fetch("lat")
  @lng = location.fetch("lng")

  cookies["last_location"] = @formatted_address
  cookies["last_lat"] = @lat
  cookies["last_lng"] = @lng





  erb(:umbrella_results)
end







get("/single_message") do
  erb(:single_message)
end


get("/ai_message") do
  erb(:single_message)
end
