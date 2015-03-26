FROM debian:jessie

# This is copy and pasted from
# <https://github.com/GoogleCloudPlatform/python-docker/blob/master/base/Dockerfile>
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y -q build-essential python2.7 python2.7-dev python-pip git

RUN pip install -U pip
RUN pip install virtualenv

# This is added for our own use:

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y uwsgi uwsgi-plugin-python && \
    rm /etc/uwsgi/ -rf

# Maybe the above should be in its own docker file, like fusionbox/python.

# Ideally I could extract these to another Dockerfile with the ONBUILD
# instruction
WORKDIR /app

RUN virtualenv /env

# [Optional] If you are building from within China, I recommend uncommenting
# this line.
# ADD chinese-sources.list /etc/apt/sources.list

# Required for psycopg2
RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install -y libpq-dev

# This will invalidate the cache everytime the requirements.txt file is
# changed, so we want don't want to impact anything with apt.
ADD ./src/requirements.txt /app/requirements.txt

RUN /env/bin/pip install -r requirements.txt

ADD ./src/ /app

VOLUME /app

ADD ./conf/uwsgi.conf /etc/uwsgi.conf

EXPOSE 8000

USER www-data

CMD ["/usr/bin/uwsgi", "--ini", "/etc/uwsgi.conf"]
