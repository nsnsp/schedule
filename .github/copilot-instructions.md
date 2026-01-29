# Copilot Instructions for NSNSP Schedule

## Project Overview
This is the official website of Northstar National Ski Patrol (NSNSP), a Ruby on Rails application for managing ski patrol schedules and commitments.

## Technology Stack
- **Framework**: Ruby on Rails 7.2.3
- **Ruby Version**: 3.4.8
- **Database**: PostgreSQL
- **Web Server**: Puma
- **Hosting**: Heroku (production and staging)
- **Testing**: MiniTest (Rails default)
- **Monitoring**: New Relic
- **Error Reporting**: Rollbar

## Deployment
- **Production**: Manual deploy via Heroku dashboard
- **Staging**: Automatic deploy on push to `main` branch
- **Heroku Stack**: 24

## Key Conventions

### Code Style
- Follow standard Ruby and Rails conventions
- Use `strip_attributes` gem for automatic attribute cleaning
- Paper Trail is used for auditing model changes

### Testing
- Tests are located in the `test/` directory
- Uses standard Rails MiniTest structure:
  - `test/controllers/` - Controller tests
  - `test/models/` - Model tests
  - `test/integration/` - Integration tests
  - `test/mailers/` - Mailer tests
- Run tests with: `rails test`

### Database
- Run migrations: `heroku run -a nsnsp rake --trace db:migrate`
- Setting up fresh database: `heroku run rake db:schema:load`
- Use `bundle lock --add-platform x86_64-linux` when recreating Gemfile.lock

### Dependencies
- Always check for platform compatibility when adding gems
- Consider Heroku deployment implications
- Prefer stable, well-maintained gems

## Development Workflow
1. Make changes locally
2. Test thoroughly using `rails test`
3. For staging: push to `main` branch
4. For production: manual deploy via Heroku

## Important Notes
- The application sends daily email notifications for commitments
- Uses Heroku Scheduler for scheduled tasks
- Integrates with Dead Man's Snitch for monitoring
- Caching is handled by Dalli (Memcached)
- Email delivery uses SendGrid

## Common Tasks
- **Running locally**: Standard Rails commands (`rails server`, `rails console`)
- **Database migrations**: Test locally first, then run on Heroku
- **Adding dependencies**: Update Gemfile, run `bundle install`, ensure platform compatibility
- **Monitoring**: Check New Relic for performance, Rollbar for errors

## Security
- Keep dependencies up to date (Dependabot is configured)
- CodeQL scanning is enabled
- Follow Rails security best practices
- Be mindful of authentication and authorization in controllers

## TODO Items
- Clean up daily email notifications (move to rake task)
- Modify Heroku Scheduler configuration
- Update Dead Man's Snitch integration
- Remove magic URL endpoints
