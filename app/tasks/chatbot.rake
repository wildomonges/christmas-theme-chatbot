# frozen_string_literal: true

namespace :chatbot do
  desc 'Zip all the code under layers/shared to be deployed as lambda layer on AWS'
  task :build_layer do
    cmd = 'cp Gemfile app/layers/shared/' \
    ' && cp Gemfile.lock app/layers/shared/' \
    ' && cd app/layers/shared/' \
    ' && rm -rf ruby/gems/' \
    ' && mkdir -p ruby/gems/3.2.0'  \
    " && bundle config set --local path 'vendor/bundle'" \
    ' && bundle config set without development test' \
    ' && bundle install --deployment' \
    ' && ls ../../../vendor/bundle' \
    ' && (cp -r ../../../vendor/bundle/ruby/3.2.0/* ruby/gems/3.2.0/ || cp -r ../../../vendor/bundle/ruby/* ruby/gems/3.2.0/)' \
    ' && rm -rf ../../../vendor/ && zip -r shared.zip ruby'

    system(cmd)

    puts 'Finished'
  end
end
