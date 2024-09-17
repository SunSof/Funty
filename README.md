# Funty
  This is a pet project aimed at learning third-party APIs. I based it on online casinos. 
  Money withdrawals are handled through the Ripple XRP API.
  The project has jobs that execute transactions for withdrawing money or top up balance. 
  Hotwire Turbo enables dynamic page processing within the application during gameplay. 
  Also user registration via Google API.
   
## Requirements

    Ruby version 3.1.2
    Rails 7.1.3
    PostgreSQL

## Installation

   1. Clone the repository: [`git clone https://github.com/SunSof/Funty.git`]
   2.Install dependencies: `bundle install`
   3.Setup database: `bundle exec rake db:create` `bundle exec rake db:migrate`

## Running

Start the server and worker: `./bin/dev`
## Testing

Run tests with RSpec: `rspec spec`
