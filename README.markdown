# Runkeeper API Client
## Work in progress - accepting patches

## Example
    user = Runkeeper.new("user token")
    puts user.name
    activity = user.new_activity(:duration => 60, :type => "Swimming", :distance => 1000
    activity.save
    puts user.activity_url(activity)

## Generating a token
    $ gem install launchy rack
    $ CLIENT_ID="your client id" CLIENT_SECRET="your secret" AUTHORIZATION_URL="https://runkeeper.com/apps/authorize" ACCESS_TOKEN_URL="https://runkeeper.com/apps/token" token_generator
    Use your browser to allow access
    Then check your console for the token
