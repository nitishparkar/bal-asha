# Bal Asha Trust

[![Build Status](https://travis-ci.org/nitishparkar/bal-asha.svg?branch=master)](https://travis-ci.org/nitishparkar/bal-asha)

Internal app for [Bal Asha Trust](http://balashatrust.org/). It helps them manage donor/donation information. It also serves as an inventory management system by keeping track of purchases and disbursements.


## Setup

1.  Run `figaro install`. This will create `config/application.yaml`.
    Assign values to the following configuration variables:

    ```
    DB_USERNAME
    DB_PASSWORD
    ```

2.  Run `rake db:setup` to create and seed database.
