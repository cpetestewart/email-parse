FROM python:3.8.10

RUN pip install cherrypy

RUN mkdir -p /opt/email_parse
WORKDIR /opt/email_parse

COPY email_parse.py .

EXPOSE 8080

ENTRYPOINT [ "python", "/opt/email_parse/email_parse.py" ]