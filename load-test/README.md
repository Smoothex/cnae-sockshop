The code is adapted from the [microservices-demo/load-test](https://github.com/microservices-demo/load-test) provided by the creators of SockShop.
# Load testing

These tests simulate actual end user usage of the application. They are used to validate the overall functionality and can also be used to put simulated load on the system. The tests are written using [locust.io](http://locust.io).

### Requirements 
* [locust](https://github.com/locustio/locust): `pip install locust`
* [locust-plugins](https://github.com/SvenskaSpel/locust-plugins): `pip install locust-plugins`

## Running locally

Start the test by running the command

```
./runLocust.sh -h [host] -u [number of concurrent clients] -r [spawn rate per seconds] -i [number of iterations]
```

### Parameters
* `[host]` - The hostname (and port if applicable) where the application is exposed. (Required)
* `[number of clients]` - Peak number of concurrent Locust users. (_Optional_: Default is 2)
* `[spawn rate]` - Specifies the rate at which new simulated users are spawned per second during a load test. Increases until the peak number of concurrent users is reached. (_Optional_: Default is 1)
* `[number of iterations]` - The total number of iterations of the load test. (_Optional_: Default is 10)

**Note**: if you want to use the Locust UI, remove the `--headless` parameter from the _runLocust.sh_ script. When you then run the command, the UI will start up allowing you to tune the load and then you can start the test manually

## Helpful information regarding the test
1. At the beginning a user object is initiated with random username, password, email, card details and address details
2. When the object is started we use the `on_start` method to define some steps in our setup preparation like:
    * user registration
    * card and address creation
3. Afterwards `Locust` starts executing the marked with `@task` methods. If we have more than one we can also add weight like `task(NUMBER_FROM_1_TO_5)` which will indicate that the task with the higher weight should be executed first. In these tasks we can create whatever scenario we need using HTTP requests as can be seen in the `locustfile.py`.
4. At the end we have an `on_stop` method which is called when the test reach its end where we delete the created test users.
