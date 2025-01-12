# URL Shortening Service

## Objective
This project implements a URL shortening service using Ruby on Rails.

## Brief
`url-shortener` is a where you enter a URL such as `https://codesubmit.io/library/react` and it returns a short URL such as `http://your.domain/GeAi9K`.

## Endpoints
 The service provides two endpoints:
- `/encode`: Encodes a URL to a shortened URL.
- `/decode`: Decodes a shortened URL to its original URL.
- You use the shortened URL itself, you will be directed to the original URL site.

## Postman collection
  Use Postman app to import the api collection at `misc/url-shortener.postman_collection.json`

## Running the project
### Prerequisites
- Ruby 3.3.0
- Rails 7.1
- Docker
- SQLite 3
### Steps
#### Running on local macine
1. Clone the project
2. Install dependencies: `bundle install`
3. Get the master key (config/master.key)
4. Create & migrate the database: `rails db:prepare`
5. Create `.env` file as `root` folder, copy & paste as follow
```plaintext
SHORT_CODE_LENGTH           = 5
BASE_URL                    = http://localhost:3000
PORT                        = 3000
RETRY_LIMIT                 = 5
```
6. Start the web server `rails s`
7. Running test:
```bash
# if you are using bash
$ RAILS_ENV=test rspec spec
# if you are using zsh with omz (rails plugin installed)
$ RET rspec spec
```

#### Running with Docker
1. Clone the project
2. Making sure your docker daemon was running
3. Disable SSL enforce for production
```diff
# root/config/environments/production.rb
- config.force_ssl = true
+ config.force_ssl = false
```
4. Build the image
```bash
$ docker build -t url-shortener-alpine:local .
```
5. Running the image
```bash
$ docker run -d -p 3000:3000 --name url-shortener-alpine -e SECRET_KEY_BASE_DUMMY=1 -e BASE_URL=localhost:3000 url-shortener-alpine:local
```

## Potential Attack Vectors and Mitigations
1. Distributed Denial of Service (DDoS):
   - Since the demo is public, it could be a target of DDoS attacks. Implementing rate limiting to prevent abuse of the service is crucial. Using Cloudflare's service to prevent DDoS attacks could be the first step. Additionally, adding `rack-attack` could help mitigate these attacks.

## Scalability Considerations
### Horizontal Scaling:
- Use a load balancer to distribute traffic across multiple instances of the application. This could be done with Dokku, but due to current resource limitations in the homelab, this cannot be done.

### Caching:
- Implement caching for frequently accessed URLs to reduce database load. This could mean adding a `count_cache` column to the `Urls` table. It should increase the count cache, and at a certain point (e.g., after 100 reads), we will cache this `short_code` in memory. Then, the 101st read request, we will take the `original_url` from the memory this could reduce the load on the database.

## Nice to have features
1. Blacklisted malicious site and explicit content site.
2. Implement branding URL for example: `https://example.com/dBrand/linus-iphone-case`
3. Bulk URL creation: Allow users to create multiple shortened URLs in a single request, which can save time and improve efficiency for users who need to shorten many URLs at once.
4. Scheduled deletion of URLs: Implement a cron job to automatically delete URLs after a certain period (e.g., 30 days), except for those with the highest `count-cache` numbers.


## Deployment (Dokku - A Heroku-like on your own server)
Please following this [documentation](https://dokku.com/docs/getting-started/installation/) for how to deploy with dokku :rocket:

### The steps below is the deployment with my homelab
### Prerequisites
```bash
$ gem install dokku-cli
```

### Steps
```bash
# On your host
$ dokku apps:create "app-name"

# On local machine
$ git remote add dokku dokku@your-domain:app-name

## Ask for a master key or prefer to create new one below, this is crucial for the creating DB...
$ dokku config:set RAILS_MASTER_KEY=master-key-go-here

$ dokku config:set BASE_URL=your-domain-go-here
$ git push dokku main

# Go to your host again
$ dokku domains:set "app-name" "your-url-go.here"
$ dokku letsencrypt:set "app-name" email "your-email@here.com"
$ dokku letsencrypt:enable "app-name"
$ dokku letsencrypt:cron-job --add

DONE
```

## Regenerating the Master Key in Rails
1. Delete the Existing Credentials File:
   - Delete the `config/credentials.yml.enc` file.

2. Generate a New Master Key:
   - Run the following command to generate a new master key and credentials file:
     ```bash
     EDIT=nano rails credentials:edit
     ```
3. Hit `Ctrl+ X` then `Y + Enter`:
   - The key should be stored in `config/master.key` file.
