# Load / Integration Tests

These tests simulate actual end user usage of the application. They are used to validate the overall functionality and can also be used to put simulated load on the system. The tests are written using [locust.io](http://locust.io)

### Parameters
* `[host]` - The hostname (and port if applicable) where the application is exposed. (Required)
* `[number of clients]` - The nuber of concurrent end users to simulate. (Optional: Default is 2)
* `[number of requests]` - The total number of iterations of the load test. (Optional: Default is 10)
//TODO: find out if the number of iterations is equal to the total requests number and edit the line above accordingly

## Running locally

### Requirements 
* [locust](https://github.com/locustio/locust) `pip install locustio`
* [locust-plugins](https://github.com/SvenskaSpel/locust-plugins) `pip install locust-plugins`
* Start command `./runLocust.sh -h [host] -c [number of clients] -i [number of requests]`


## Running in Docker Container
* Build `docker build -t load-test .`
* Run `docker run load-test -h [host] -c [number of clients] -i [number of requests]`
