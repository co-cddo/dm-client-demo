# Data Marketplace (DM) Client Demo

This is a proof of concept application that demonstrates how an application can
use API calls to push data into the Data Marketplace, and read and update that
data.

## Manually create records

This application allows records to be created manually at `records/new`.
When the record is created it is compared with a Metadata Schema to
determine if it is valid and the results flagged to the user via the tags
"Valid" and "Invalid".

## Ordnance Survey (OS) Data

The application includes a tool (`OS::Populator`) that pulls data from an
OS API and generates DM compatible metadata from it. It is then possible
to use this application to push that data into the Data Marketplace.

## Connection to other services

### Data Marketpace API

To connect to the Data Marketplace API a client ID and Secret are required.
These are obtained from the Data Marketplace portal. Use the following
environment variables to set these parameters for the current instance:

- **DM_CLIENT_ID**
- **DM_CLIENT_SECRET**

You can also use the following environment variables to set the location
of the Data Marketplace instance that you want the instance of this application
to connect to:

- **DM_ROOT_URL** The HTTP UI root URL for the Data Marketplace (its home page)
- **DM_API_ROOT_URL** The root URL for the Data Marketplace API

### Google authentication

This application uses Google authentication to make it easier for users to log in.
The gem
[_omniauth-google-oauth2_](https://github.com/zquestz/omniauth-google-oauth2)
is used to provide this functionality, and that gem's README provides details of
how it is configured.

For a user to be able to log in the user must exist in the local
database. That is, normally you will need to create a user at `/users` before
they will be able to log in.

The first user is set via seeds. Alternatively a user can be created at the
rails console.

For Google authentication to work a set of valid Google credentials need to be
set using the environment variables:

- **GOOGLE_CLIENT_ID**
- **GOOGLE_CLIENT_SECRET**

## Local installation
This is a Ruby on Rails application and requires Ruby and PostgesSQL installed.

- Clone this application to your local environment
- cd into the application root
- run `bundle` to install the required ruby gems
- run `rails db:create` and `rails schema:load` to set up the database
- run `rake javascript:build` to set up the JavaScript environment
- run `rake dartsass:build` to set up SASS

You should then be able to run a local instance of the application using `rails s`

### Rails Credentials
The environment variables needed to configure this application can be set using
Rails Credentials. The following need to be included in the encrypted file:

```
dm_api:
  rootApiUrl: 'apidev.datamarketplace.gov.uk'
  rootUrl: 'dev.datamarketplace.gov.uk'
  clientId: '<DM client ID'
  clientSecret: '<DM client secret>'

google:
  clientId: '<Google client ID>'
  clientSecret: '<Google client Secret>'
```

## Continual Integration (CI)
The CI pipeline for this application is run via github actions.

The following CI elements can be run locally before deployment.

### Tests
To run the test locally use the command `rspec`

### Linting
Use Rubocop to check the Ruby code of this application locally. The following
command will both find any problems and attempt to fix them: `rubocop -A`

### Vulnerability testing
Use the command `brakeman` to locally run a vulnerability test on the code
