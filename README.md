# InfinibirdWeb

A web application fully built in Elixir and Phoenix. It's a part of system which analyzes, computes, aggregates and visualizes the telematics data gathered while driving a car, on interactive charts and geographic map.

Communicates with distributed system TANGO which gathers the data from a huge amount of users.

Supported for every major browser and prepared for desktops and mobile devices, according to the responsive web design.

Application is build from two main components:

- `infinibird_service`: a microservice responsible for backend functionality, communication layer and database.
- `infinibird_web`: Phoenix app responsible for routing, user session and presentation layer.

## Testing

The best way to see this application in action is to visit the website:

[`https://infinibird.gigalixirapp.com`](https://infinibird.gigalixirapp.com)

And use the testing token: `549af9e4`

## Building local environment

To start the app:

- Download the project.
- Install dependencies with `mix deps.get`
- Install Node.js dependencies with `cd assets && yarn install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:5000`](http://localhost:5000) from your browser.
