# Example Ruby Application Project #

This is a small application example that uses Ruby on Rails to provision a simple web site that responds to a root request `/` with a page containing information about its environment and also the result of a request to the example Api project from the `CMpExampleApi1` repository.

The application will listen for requests on **port 8080**. Note that this is the port number the build pipe lines will use when defining the ECS tasks and load balancer rules. Changing the application to use a different port will result in incorrect deployment of the resulting container.

In addition to the standard rails setup it makes use of two other packages of note:

CSS and JS from `govuk-frontend` [https://github.com/alphagov/govuk-frontend](https://github.com/alphagov/govuk-frontend)

This is the GOV UK front end tool kit and it provides the basic styling for the example application.
These files have been taken and modified slightly to enable a similar Look and Feel to `CMpExampleApp1`

`rest-client` [https://github.com/rest-client/rest-client](https://github.com/rest-client/rest-client)

This is a Ruby gem that eases calling of a ReST API.

## Local Execution ##
To execute locally, Ruby and Ruby on Rails are installed, checkout the repository from Github and execute the following:

```
bundle install
ruby bin/rails server
```

A web browser request to `http://localhost:8080/` should result in a page being displayed. This will probably include an error relating to the attempt to invoke the example api: api1.

If you have a local copy of the api running under Docker (see `CMpExampleApi1` repository) and listening on port `18080`, and assuming your local Docker machine is using IP `192.168.99.100` add the following to your hosts file:

`192.168.99.100 api1.internal.cmpdev.crowncommercial.gov.uk`

Then define the following environment variable:

`set CCS_API_BASE_URL=internal.cmpdev.crowncommercial.gov.uk:18080`

Running the application again and accessing `http://localhost:8080/` should now result in the Api call succeeding. It is important that the request to the api is made using the host name defined in the rules for the load balancer attached to the ECS Api cluster, the default being `api1.internal.cmpdev.crowncommercial.gov.uk`.

If you are building and running the example Api locally as a Java application change `192.168.99.100` to `127.0.0.1`.

## Dockerfile ##
The project includes a simple Docker file, this is used by the build pipeline to generate the container image. It must expose port 8080. If Docker is installed it can be executed locally.

To build the Docker image locally execute:

`docker image build -t ccs/app2 .`
