FROM ruby:2.5.1-stretch
RUN apt-get update -qq && apt-get install -y nodejs && apt-get install -y mysql-server && apt-get -y install netcat

WORKDIR /app
 
COPY Gemfile Gemfile.lock  ./
 
RUN bundle update mimemagic
RUN bundle install 
 
COPY . .  
 
# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 8080

# CMD ["rails", "server", "-b", "0.0.0.0"]



