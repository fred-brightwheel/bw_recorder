## Setup

Install Ruby on Rails: https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails

`bundle install`
`bundle exec rails s` 

APIs should be available at `http://localhost:3000`


## Sending Device Readings

`POST /readings`

Request Body:

```
{
    "id": [uuid],
    "readings": [
        {
            "timestamp": [iso8601 timestamp],
            "count": [integer]
        }
    ]
}
```

### Example cURL Request
```
curl --location --request POST 'localhost:3000/readings' \
--header 'Content-Type: application/json' \
--header 'Cookie: __profilin=p%3Dt' \
--data-raw '{
    "id": "abc-123",
    "readings": [
        {
            "timestamp": "2021-09-28T22:25:44Z",
            "count": "100"
        }
    ]
}'
```

## Getting Total Device Count

`GET /devices/:id/total_count`

Response Body:

```
{
    "count": 100
}
```

### Example cURL Request
```
curl --location --request GET 'localhost:3000/devices/abc-123/total_count' \
--header 'Cookie: __profilin=p%3Dt'
```

## Getting Latest Device Count

`GET /devices/:id/latest_count`

Response Body:

```
{
    "count": 100
}
```

### Example cURL Request

```
curl --location --request GET 'localhost:3000/devices/abc-123/latest_count' \
--header 'Cookie: __profilin=p%3Dt'
```

---

# Brightwheel Take-Home Exercise

Thanks for your interest in Brigthwheel!
We ask that you limit yourself to a maximum of two hours when working on this.
If you run out of time, don't worry - add some notes in your README to describe what you would have worked on given more time.

## Summary

For this exercise, imagine that we have devices that record an integer at arbitrary intervals. These records are then sent out over the internet as HTTP requests.
We would like you to implement a simple web API that receives these requests.

## Request Format

### Recording Readings

Your API service should accept `POST` HTTP requests from these devices. Request bodies will contain JSON payloads in the following format:

```json
{
    id: (string) The device identifier. This will be a uuid.
    readings: [
        {
            timestamp: (string) Timestamp for the reading in [iso 8601 format](https://en.wikipedia.org/wiki/ISO_8601)
            count: (integer)
        }
    ]
}
```

Note that a single request can account for multiple readings.

### Returning Data

It should also expose two HTTP endpoints that return the following information:

* The most recent count for a given device id.
* The cumulative count for a given device id.

You are free to define the HTTP routes and response payloads for these as you see fit.

## Other Requirements

### Device Requests

These devices are unreliable. As such:

* Readings may be sent out of order.
* Devices will occasionally send duplicate `POST` requests. These should be ignored.
* Both `POST` request bodies and individual readings may be malformed. Malformed readings should be ignored.

### Data Persistence

If your application persists data to disk (this is up to you), **do so in a plain text format** (e.g. CSV, json, etc).
**Please do not use a third-party database**.

### Third-Party Libraries

Other than the database requirement above, feel free to use any third-party libraries you deem appropriate.
If you do, make sure to include instructions on how to install them.

## Additional Considerations

The following aren't necessary in a good solution, but we will notice if you solve for them, anticipate them, or discuss them in your README.

* What happens if your application needs to be restarted?
* Does anything change if so many readings are sent that they no longer fit into memory at the same time?
* We're fans of automated testing. How can we verify the application is working?

## README

Please include a `README.md` file with your exercise. It should include:

* Instructions on how to start up your application
* Any notes on design decisions
* Anything you would have included given more time
