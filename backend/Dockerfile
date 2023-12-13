FROM public.ecr.aws/sam/build-ruby3.2:latest

WORKDIR /chatbot

RUN yum install -y ruby ruby-devel git-core libyaml-devel wscat \
  && yum clean all \
  && gem update --system \
  && gem install bundler \
  && yum install -y amazon-linux-extras

RUN yum groupinstall -y 'Development Tools'

RUN bundle config set with "development test"

RUN bundle config set path vendor/bundle

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler:2.4.10

COPY .env .env

RUN export AWS_ACCESS_KEY_ID=$(echo "$(cut -d'=' -f2 <<< $(grep AWS_ACCESS_KEY_ID .env) )") && \
  export AWS_SECRET_ACCESS_KEY=$(echo "$(cut -d'=' -f2 <<< $(grep AWS_SECRET_ACCESS_KEY .env) )") && \
  export AWS_REGION=$(echo "$(cut -d'=' -f2 <<< $(grep AWS_REGION .env) )")

COPY . .

RUN bundle install

CMD [ "/bin/bash" ]