Bal Asha Trust
=============

Internal app for [Bal Asha Trust](http://balashatrust.org/)


Setup
=============
1.  Run `figaro install`. This will create `config/application.yaml`.
    Assign values to the following configuration variables:

    ```
    DB_USERNAME
    DB_PASSWORD
    ```

2.  Run `rake db:setup` to create and seed database.