This repo contains files to get Bugzilla working from a docker container. I couldn't find
any other Docker based Bugzilla implementations that built a docker container to run
the web service in it's own container.

We make assumptions about the environment it's running in. Namely, AWS, since that's what 
we use. Also, this is meant to be run with a separate database server. We don't attempt
to cover how to setup or manage the database.

This can be stood up locally via the following:
```
docker-compose up
docker exec -it bugzilla-docker /bin/bash
lynx localhost
```
