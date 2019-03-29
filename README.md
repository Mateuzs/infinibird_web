# Infinibird

Responsive web app computing, aggregating data and visualising it on interactive charts and geographic map.  
Communicates with huge distributed system in order to get data about a multitude of users.  
Users and computed data are stored in DB, ready to be served.

It's build from two main components:

- infinibird_engine: back-end functionality, genServer, genSupervisor, API, database communication, data computing, etc. separate Elixir app.
- infinibird_web: Phoenix app, routing, user session, presentation layer, front-end stuff.

To start the app:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `cd assets && yarn install`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
