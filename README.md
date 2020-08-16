# NWS Client

A Crystal library for querying the United States' National Weather Service API.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     nws-client:
       github: dscottboggs/nws-client
   ```

2. Run `shards install`

## Usage

```crystal
require "nws-client/gridpoints/forecast"

NWSClient.gridpoints("PBZ", 74, 68)
  .forecast
  .properties
  .periods
  .each do |forecast|
    puts "it will be #{forecast.temperature} #{forecast.name}"
  end
```

Output:

```
it will be 81 Today
it will be 62 Tonight
it will be 82 Tuesday
it will be 58 Tuesday Night
it will be 82 Wednesday
it will be 58 Wednesday Night
it will be 86 Thursday
it will be 62 Thursday Night
it will be 89 Friday
it will be 65 Friday Night
it will be 88 Saturday
it will be 65 Saturday Night
it will be 85 Sunday
it will be 64 Sunday Night
```

## Development

Not all API endpoints are currently implemented. If you need to query an
endpoint which hasn't been implemented yet, the procedure for implementing
it is:

1. Download a sample(s) from the endpoint you want to be able to query from Crystal

```sh
curl -L api.weather.gov/gridpoints/PBZ/74,68/forecast > src/types/gridpoints_forecast.json
```

2. Run [`jenerator`](https://github.com/dscottboggs/jenerator) on the downloaded sample(s).

```sh
cd samples
jenerator .
```

3. Write a spec for the new type, based on the existing examples in the `spec`
   dir, which tests that your generated types successfully parse the sample
   you downloaded.

4. Edit the generated file(s) until the specs pass. This involves removing
   redundant ArrayMember types, and changing any `Nil` types to the optional of
   what they're expected to be (i.e. `String?` or `Float64?`). This may include
   pulling class definitions from nested structures other redundant ArrayMember
   types. This is definitely the hardest part of the process, but it should only
   take a few minutes.

5. Add a `fetch` class method to your type:

   - If your query can be constant, assign it to `FETCH_PATH` in your type, and
     include APIHelper. See `src/types/alerts.cr` for an example.
   - If your query needs some parameters, define a custom `fetch` method like in
     `src/types/gridpoints_forecast.cr`

6. Add a convenience class method to the NWSClient in `src/nws-client/`. This
   method and any support types should be defined in a single file in that
   folder. For example:

   - alerts queries should be requirable with `require "nws-client/alerts"`
   - all queries related to gridpoints should be requirable with
     `require "nws-client/gridpoints"`, while the forecasts for a gridpoint
     should be able to be required with
     `require "nws-client/gridpoints/forecast"`.

   These client files should only require the types under `src/types/` which
   are needed to make a given request.

## Contributing

1. Fork it (<https://github.com/dscottboggs/nws-client/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [D. Scott Boggs](https://github.com/dscottboggs) - creator and maintainer
