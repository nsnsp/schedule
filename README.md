NSNSP
=====
[![Stack Share](http://img.shields.io/badge/tech-stack-0690fa.svg?style=flat)](http://stackshare.io/rossdakin/northstar-national-ski-patrol)
[![Dependency Status](https://gemnasium.com/rossdakin/nsnsp.svg)](https://gemnasium.com/rossdakin/nsnsp)

The official website of Northstar National Ski Patrol.

**TODO**

Hello world!

Clean up daily email notifications
- move `CommitmentsController::notify_day` into a rake task
- modify Heroku Scheduler to run the rake task rather than curl a magic URL
- modify Dead Man's Snitch to receive ping from their Ruby gem rather than curl
- clean up: get rid of the magic URL, temporatize plugin and config token, etc.

**Notes**

Dev
- Works, but auth broken.
- If blowing away Gemfile.lock to recreate, [do this](https://devcenter.heroku.com/articles/bundler-version#known-upgrade-issues) after `bundle install`: `bundle lock --add-platform x86_64-linux`

Deployment
- production: push to `master`
- staging: push to `staging`

Running migrations: `heroku run -a nsnsp rake --trace db:migrate`

