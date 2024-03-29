FROM fedora:30

# Setup volume for output
#VOLUME /opt/robotframework/reports

WORKDIR /app
COPY ./ ./

# Setup X Window Virtual Framebuffer
ENV SCREEN_COLOUR_DEPTH 24
ENV SCREEN_HEIGHT 1080
ENV SCREEN_WIDTH 1920

# Set number of threads for parallel execution
# By default, no parallelisation
ENV ROBOT_THREADS 1

# Dependency versions
ENV CHROMIUM_VERSION 75.0.*
ENV DATABASE_LIBRARY_VERSION 1.2
ENV FAKER_VERSION 4.2.0
ENV FIREFOX_VERSION 68.0*
ENV FTP_LIBRARY_VERSION 1.6
ENV GECKO_DRIVER_VERSION v0.22.0
ENV PABOT_VERSION 0.63
ENV PYTHON_PIP_VERSION 19.0*
ENV REQUESTS_VERSION 0.5.0
ENV ROBOT_FRAMEWORK_VERSION 3.1.2
ENV SELENIUM_LIBRARY_VERSION 3.3.1
ENV SSH_LIBRARY_VERSION 3.3.0
ENV XVFB_VERSION 1.20.*

# Prepare binaries to be executed
COPY bin/chromedriver.sh /app/opt/robotframework/bin/chromedriver
RUN chmod +x /app/opt/robotframework/bin/chromedriver
COPY bin/chromium-browser.sh /app/opt/robotframework/bin/chromium-browser
RUN chmod +x /app/opt/robotframework/bin/chromium-browser
COPY bin/run-tests-in-virtual-screen.sh /app/opt/robotframework/bin/
RUN chmod +x /app/opt/robotframework/bin/run-tests-in-virtual-screen.sh
COPY bin/run-smoke-test-in-virtual-screen.sh /app/opt/robotframework/bin/
RUN chmod +x /app/opt/robotframework/bin/run-smoke-test-in-virtual-screen.sh


# Install system dependencies
RUN dnf upgrade -y \
  && dnf install -y \
    chromedriver-$CHROMIUM_VERSION \
    chromium-$CHROMIUM_VERSION \
    firefox-$FIREFOX_VERSION \
    python3-pip-$PYTHON_PIP_VERSION \
    xauth \
    xorg-x11-server-Xvfb-$XVFB_VERSION \
    which \
    wget \
  && dnf clean all \
  && mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original \
  && ln -sfv /app/opt/robotframework/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser
# FIXME: above is a workaround, as the path is ignored

# Make python 3 the default python      
RUN alternatives --install /usr/bin/python python /usr/bin/python3.7 2 \
  && alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# Install Robot Framework and Selenium Library
RUN pip3 install \
  --no-cache-dir \
  robotframework==$ROBOT_FRAMEWORK_VERSION \
  robotframework-databaselibrary==$DATABASE_LIBRARY_VERSION \
  robotframework-faker==$FAKER_VERSION \
  robotframework-ftplibrary==$FTP_LIBRARY_VERSION \
  robotframework-pabot==$PABOT_VERSION \
  robotframework-requests==$REQUESTS_VERSION \
  robotframework-seleniumlibrary==$SELENIUM_LIBRARY_VERSION \
  robotframework-sshlibrary==$SSH_LIBRARY_VERSION \
  PyYAML

# Download Gecko drivers directly from the GitHub repository
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/$GECKO_DRIVER_VERSION/geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz" \
      && tar xzf geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz \
      && mkdir -p /app/opt/robotframework/drivers/ \
      && mv geckodriver /app/opt/robotframework/drivers/geckodriver \
      && rm geckodriver-$GECKO_DRIVER_VERSION-linux64.tar.gz

#Install NodeJS Http server
RUN dnf clean all
RUN dnf -y install nodejs npm
RUN npm install -g http-server
   


# Update system path
ENV PATH=/app/opt/robotframework/bin:/app/opt/robotframework/drivers:$PATH

#EXPOSE PORT ON AWS BEANSTALK
EXPOSE 8000

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
