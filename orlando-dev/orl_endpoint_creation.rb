Publisher.create! do |pub|
  pub.title = "OPD Reports"
  pub.endpoint = "http://orlando-citygram-api.azurewebsites.net/?service=police"
  pub.active = true
  pub.visible = true
  pub.city = "Orlando"
  pub.icon = "police-incidents.png"
  pub.state = "FL"
  pub.description = "Incident reports from the OPD. Reports are delayed for x days."
  pub.tags = ["orlando","orl","crime","police"]
end

Publisher.create! do |pub|
  pub.title = "Landmarks"
  pub.endpoint = "http://orlando-citygram-api.azurewebsites.net/?service=landmarks"
  pub.active = true
  pub.visible = true
  pub.city = "Orlando"
  pub.icon = "landmarks.png"
  pub.state = "FL"
  pub.description = "Offical list of historical landmarks in the City of Orlando."
  pub.tags = ["orlando","orl","landmark","pointsofinterest"]
end
