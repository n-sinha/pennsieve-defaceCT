FROM freesurfer/freesurfer:7.4.1

# Copy license
COPY license.txt /usr/local/freesurfer/.license

WORKDIR /service
COPY . .
RUN mkdir -p data
RUN chmod +x /service/main.sh

ENTRYPOINT ["/service/main.sh"]
