The code is adapted from the [microservices-demo/load-test](https://github.com/microservices-demo/load-test) provided by the creators of SockShop.
# Load testing

These tests simulate actual end user usage of the application. They are used to validate the overall functionality and can also be used to put simulated load on the system. The tests are written using [locust.io](http://locust.io).

### Requirements 
* [locust](https://github.com/locustio/locust) `pip install locust`
* [locust-plugins](https://github.com/SvenskaSpel/locust-plugins) `pip install locust-plugins`

## Running locally

Start the test by running the command

`./runLocust.sh -h [host] -u [number of clients] -r [spawn rate] -i [number of iterations]`

### Parameters
* `[host]` - The hostname (and port if applicable) where the application is exposed. (Required)
* `[number of clients]` - Peak number of concurrent Locust users. (_Optional_: Default is 2)
* `[spawn rate]` - Specifies the rate at which new simulated users are spawned per second during a load test. Increases until the peak number of concurrent users is reached. (_Optional_: Default is 1)
* `[number of iterations]` - The total number of iterations of the load test. (_Optional_: Default is 10)


## Running in Docker Container
* Build `docker build -t load-test .`
* Run `docker run load-test -h [host] -c [number of clients] -r [number of requests]`
