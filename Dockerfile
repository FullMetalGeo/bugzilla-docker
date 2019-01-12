FROM ubuntu:18.04
MAINTAINER Adam Chou <adam.chou@radiantsolutions.com>

# Update and install modules for bugzilla, Apache2
RUN apt update && \
DEBIAN_FRONTEND=noninteractive apt install -q -y supervisor gcc \
apache2 expat libexpat1-dev curl \
libapache2-mod-perl2 libmath-random-isaac-perl \
liblist-moreutils-perl libencode-detect-perl libdatetime-perl \
msmtp msmtp-mta libnet-ssleay-perl libcrypt-ssleay-perl \
libappconfig-perl libdate-calc-perl libtemplate-perl libmime-tools-perl build-essential \
libdatetime-timezone-perl libdatetime-perl libemail-sender-perl libemail-mime-perl \
libemail-mime-modifier-perl libdbi-perl libcgi-pm-perl \
libmath-random-isaac-perl libmath-random-isaac-xs-perl apache2 apache2-bin \
libapache2-mod-perl2 libapache2-mod-perl2-dev libchart-perl libxml-perl \
libxml-twig-perl perlmagick libgd-graph-perl libtemplate-plugin-gd-perl \
libsoap-lite-perl libhtml-scrubber-perl libjson-rpc-perl libdaemon-generic-perl \
libtheschwartz-perl libtest-taint-perl libauthen-radius-perl libfile-slurp-perl \
libencode-detect-perl libmodule-build-perl libnet-ldap-perl libauthen-sasl-perl \
libtemplate-perl libfile-mimeinfo-perl libhtml-formattext-withlinks-perl \
libmath-random-isaac-perl libjson-xs-perl libemail-reply-perl libfile-copy-recursive-perl \
libgd-dev lynx graphviz python-sphinx patch libdbd-pg-perl libdatetime-perl && \
rm -rf /var/lib/apt/lists/*

# Configure Apache
COPY bugzilla.conf /etc/apache2/sites-available
RUN a2dismod mpm_event && \
    a2dissite 000-default && \
    a2ensite bugzilla && \
    a2enmod mpm_worker cgi headers expires rewrite && \
    rm -rf /var/www/html && \
    ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

WORKDIR /var/www/html/

# Install Bugzilla
ENV BUGZILLA_VERSION="5.0.4"
RUN curl https://github.com/bugzilla/bugzilla/archive/release-${BUGZILLA_VERSION}.tar.gz \
    -Lo /tmp/release-${BUGZILLA_VERSION}.tar.gz && \
    tar -xvf /tmp/release-${BUGZILLA_VERSION}.tar.gz --strip-components=1 -C /var/www/html && \
    # Enable the bug voting extension
    rm -f /var/www/html/extensions/Voting/disabled && \
    chown -R www-data:www-data /var/www/html && \
    rm -f /tmp/release-${BUGZILLA_VERSION}.tar.gz

RUN curl https://github.com/FullMetalGeo/aws-env/raw/master/bin/aws-env-linux-amd64 -Lo /bin/aws-env && \
    chmod +x /bin/aws-env
COPY docker-entrypoint.sh /var/www/html/

CMD [ "/bin/bash", "/var/www/html/docker-entrypoint.sh" ]
