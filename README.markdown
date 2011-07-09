# Runkeeper API Client
## Work in progress - accepting patches

## Example
    user = Runkeeper.new("user token")
    puts user.name
    activity = user.new_activity(:duration => 60, :type => "Swimming", :distance => 1000
    activity.save
    puts user.activity_url(activity)
