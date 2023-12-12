FROM public.ecr.aws/sam/build-ruby3.2:latest

WORKDIR /chatbot

RUN yum install -y ruby ruby-devel git-core libyaml-devel \
  && yum clean all \
  && gem update --system \
  && gem install bundler \
  && yum install -y amazon-linux-extras \
  && PYTHON=python2 amazon-linux-extras install -y postgresql14 \
  && yum install -y postgresql-devel

RUN yum groupinstall -y 'Development Tools'

RUN bundle config set with "development test"

RUN bundle config set path vendor/bundle

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler:2.4.10

COPY .env .env

COPY . .

RUN bundle install

CMD [ "/bin/bash" ]