#!/bin/bash

# No need for the overhead of Pabot if no parallelisation is required
if [ $ROBOT_THREADS -eq 1 ]
then
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
        robot \
        --outputDir /app/reports \
        --BROWSER=chrome ${ROBOT_OPTIONS} \
        /app/test
else
    xvfb-run \
        --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" \
        pabot \
        --verbose \
        --processes $ROBOT_THREADS \
        --outputDir /opt/robotframework/reports \
        ${ROBOT_OPTIONS} \
        /opt/robotframework/tests
fi

# Run HTTP server
http-server /app/reports -p 8000
