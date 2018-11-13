FROM ubuntu:16.04
RUN useradd -ms /bin/bash docker
COPY --chown=docker:docker . /SCALe
WORKDIR /SCALe
ENV SCALE_HOME="/SCALe"
ENV GEM_HOME="/SCALEe/scale.app/vendor/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
RUN apt-get update && apt-get install -y -f \ 
    wget \
    build-essential=12.1ubuntu2  \
    sqlite3=3.11.0-1ubuntu1 \
    sqlite3-pcre=0~git20070120091816+4229ecc-0ubuntu1 \
    ruby=1:2.3.0+1 \
    ruby2.3-dev \
    rubygems-integration=1.10 \
    python=2.7.12-1~16.04 \
    libncurses5-dev=6.0+20160213-1ubuntu1 \
    libssl-dev=1.0.2g-1ubuntu4.13 \
    libsqlite3-dev=3.11.0-1ubuntu1 
RUN wget http://tamacom.com/global/global-6.5.1.tar.gz
RUN tar -xzf global-6.5.1.tar.gz
RUN cd global-6.5.1 && ./configure && make && make install
RUN gem install json_pure -v 1.8.3
RUN gem install bundler
USER docker
WORKDIR ${SCALE_HOME}/scale.app
RUN bundle install --binstubs && bundle exec rake db:migrate
CMD ["bundle", "exec", "thin", "start", "--port", "8080"]
EXPOSE 8080
