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

On you local machine, you should have three branches,

1. **master** pointing to **GitHub** repo's **master**

2. **phase2** pointing to **GitHub** repo's **phase2**

3. **deploy** pointing to **Bitbucket** repo's **master**

All the new features/enhancements should be added on the phase2 branch. At the end of the phase, phase2 branch will be merged into master. Only bugfixes should happen on the master branch. To deploy: merge master into deploy, push deploy to bitbucket and then `cap deploy`.