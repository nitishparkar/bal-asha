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


Git Strategy
=============

Due to some issues with Figaro, we are using a private bitbucket repo to deploy this app.

On you local machine, you should have two branches,
1. **master** pointing to **GitHub** repo's **master**
2. **deploy** pointing to **Bitbucket** repo's **master**

All changes and bugfixes should happen on the master branch. To deploy: merge master into deploy, push deploy to bitbucket and then `cap deploy`.