# Bal Asha

Internal app for [Bal Asha Trust](http://balashatrust.org/). It helps them manage donor/donation information. It also serves as an inventory management system by keeping track of purchases and disbursements.


## Setup

1.  Run `figaro install`. This will create `config/application.yaml`.
    Assign values to the following configuration variables:

    ```
    DB_USERNAME
    DB_PASSWORD
    ```

2.  Run `rake db:setup` to create and seed database.

## Running tests

#### Running all tests:
```
rake test
```

#### Running specific test(s):
```
rake test TEST=test/models/donation_test.rb TESTOPTS="--name=/receipt_number/ -v"
```

## Deploying the app

The app currently uses [mina](http://nadarei.co/mina/) for deployment. Deployment config can be found [here](https://github.com/nitishparkar/bal-asha/blob/master/config/deploy.rb).

#### Install mina
```
gem install mina -v 0.3.8
```

#### Deploy
```
BALASHA_PROD_USER=<username> BALASHA_PROD_SERVER=<ip/name> mina deploy --verbose
```

## License

See `LICENSE` file.
