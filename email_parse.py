import cherrypy
import email

class EmailParser:

    def __init__(self):
        pass

    @cherrypy.expose()
    @cherrypy.tools.json_out()
    def index( self ):
        data = cherrypy.request.body.fp.read()  # type: bytes

        mail_obj = email.message_from_bytes( data )

        return {
            'To' : mail_obj['To'],
            'From' : mail_obj['From'],
            'Subject' : mail_obj['Subject'],
            'Date' : mail_obj['Date'],
            'Message-ID' : mail_obj['Message-ID']
        }

if __name__ == '__main__':
    config = {
        'server.socket_host' : '0.0.0.0',
        'server.socker_port' : 8080
    }
    cherrypy.config.update( config )
    cherrypy.quickstart( EmailParser(), '/' )