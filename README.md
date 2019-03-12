# phoenix-uk-postcode-finder-example
An example/tutorial application showing how to rapidly find your nearest X by
typing a postcode.


This readme will take you through the steps needed to create a store finder
using Phoenix and ETS (Erlang Term Storage).

### Prerequisites?

The only pre-requisites are:

+ Basic Elixir language syntax knowledge: https://github.com/dwyl/learn-elixir
+ Basic Phoenix Framework knowledge:
https://github.com/dwyl/learn-phoenix-framework


And to make sure you have the following installed on your machine:

+ Elixir: https://elixir-lang.org/install.html
+ Phoenix: https://hexdocs.pm/phoenix/installation.html
+ PostgreSQL: https://www.postgresql.org/download

Now, let's get started 👍

### Getting started

In your terminal, make a new Phoenix application by running the command...
```
mix phx.new store_finder
```

Type `y` when asked if you want to install the dependencies. This may take a few
seconds. Once this is done, `cd` into the directory.
```
cd store_finder
```

Currently we are not using the database (may change in the near future) but in
the interest of avoiding unnecessary complication, let's create one with...
```
mix ecto.create
```

### Creating a store cache
Now that we have created our app, the next thing that we need to do is get a
list of store information. We have provided a default list of random postcodes
which we will be using as our "store information" for the purposes of this
example.

That list can be found [here](https://github.com/dwyl/phoenix-uk-postcode-finder-example/blob/master/lib/store_finder/create_stores.ex#L25-L225)

<!-- # NOTE TO SELF - Still need to add this
This can be any list of addresses that the you like, as long at the list
contains a valid UK postcode for each entry.

If you decide to use your own data you may need to edit some of the functions
that handle storing/retrieving data from/to the ets table to ensure you save the
fields your data contains. Give example of this by in a separate md file and
link to it here

You will need to run this through our function which will get the latitude and
longitude values for each postcode.

(create a function that gets the lat-long for every postcode passed in.) -->


In the `lib/store_finder` folder, create a file called `store_cache.ex` and add
the following code...
```ex
defmodule StoreFinder.StoreCache do
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: StoreCache)
  end

  def init(initial_state) do
    :ets.new(:store_cache, [:set, :public, :named_table])
    :ets.insert(:store_cache, store_list())

    {:ok, initial_state}
  end

  def store_list do
    ... # Copy the list info from the above link into this function
  end
end
```

Let's take a look at this code in a little more detail.

The `use GenServer` allows us to create a GenServer. This will allow the code in
this module to run when the application is started. We still need to do a little
more for this to happen but we will touch on that a little later. You can find
out more about GenServers [here](https://hexdocs.pm/elixir/GenServer.html).

What we are going to focus on for this example is the logic inside the `init/1`
function, specifically the two lines starting with `:ets`. These are the lines
that are going to create our `ets` table and store all of our "store"
information.

As mentioned above, ETS stands for erlang term storage. In elixir, if you want
to call an erlang function we put a `:` before the name of that module and then
call the function as we would any other elixir function.

So first we call the [`:ets.new/2`](http://erlang.org/doc/man/ets.html#new-2)
function which creates a new table for us. The arguments we give to this
function are the name that we want to call the table, `:store_cache`, and a list
of options.

The list of options we used are:
- `:set`. There are four types of tables available in ETS. `:set` is the type of table
that we want to create.
- `:public`. This dictates where we can read and write to the table from.
- `:named_table`. This registers the table under its name which can then be
used instead of the table identifier in subsequent operations.

Now that we have created our table we can insert data into it. This is where the
line below comes in.

`:ets.insert/2`, as the name suggests, inserts data into a table. The first
argument is the table name, `:store_cache`. The second argument is a list of
tuples, in our case the store list we added. And that is it. These two lines
create and store all of the info we need.

The last thing we need to do for these functions to be called when our app is
started is to update our `application.ex` file.

Open the `application.ex`. You should see something that resembles this...
(I have removed the comments to make it more concise but it should look about
the same)
```ex
defmodule StoreFinder.Application do
  use Application

  def start(_type, _args) do
    children = [
      StoreFinder.Repo,
      StoreFinderWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: StoreFinder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  ...
end
```

We will want to add our module to the list of `children`. To do this simply add
the module name to the list of children like so...
```ex
children = [
  # Start the Ecto repository
  StoreFinder.Repo,
  StoreFinderWeb.Endpoint,
  StoreFinder.StoreCache # <==== This line
]
```

Now if we start our application we will create an `ets` table, so let's give it
a go.

As we are not currently doing anything with the data from our `ets` table we
will not be able to tell if it is working by just starting the app. We should
(and will) write tests to check it is working but for right now open your
terminal and type...
```
iex -S mix
```

This will compile your application and start an interactive elixir shell. In
here type the following command...
```
:ets.match_object(:store_cache, :_)
```

This will return a list of all the "stores" saved in the `ets` table. As you
can see you didn't have to do anything to be able to access this data 😁

