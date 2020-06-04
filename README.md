# Tool app

Things you may want to cover:

* Ruby version:  **2.6.6**

* Rails version: **Rails 6.0.3.1**

* System dependencies: **only Gemfile**

* Configuration requires to set following ENV variables:
  
```
LOKALISE_PROJECT_ID
LOKALISE_API_KEY
GITHUB_ACCESS_TOKEN
GITHUB_WEBHOOK_SECRET
REPO_PATH
```
  
Place `.env` file included above variables into the app root folder  
  
Also setup Webhook for repository defined at REPO_PATH. (Pay attention on set `Pull Requests` check box under `Let me select individual events` option.)
![Webhooks](https://user-images.githubusercontent.com/4372434/83728575-3b8dd700-a64f-11ea-9dd4-59da246b7dbd.png)

NOTE: For local tests use [ngrok](https://ngrok.com/) to make webhooks work at address like `https://{ngrok-id}.ngrok.io/github_webhooks`

  
* Database creation:  **rake db:create**

* Database migrations:  **rake db:migrate**
* How to run the test suite: **bundle exec rspec**

* Services (job queues, cache servers, search engines, etc.)
 **no external serivices**
* For development environment run: `./bin/webpack-dev-server` webpack server to deliver assets

