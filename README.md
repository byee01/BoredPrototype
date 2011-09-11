Teudu
===

This is the teudu webservice. It's based off of RoR 3.1.

Deploying
---

I don't know if we're ready for that yet...
You can push back to here by typing: `git push`

And to Heroku with: `git push heroku master`

Database
---

We test online with the app deployed to Heroku. Since Heroku uses Postgres instead of sqlite, you should run bundle install with the development context.
`bundle install --without production`
