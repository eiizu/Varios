import socket

host = 'localhost'
port = 8125
udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
orig = (host, port)
udp.bind(orig)
while True:
    msg, client = udp.recvfrom(1024)
    print(client, msg)
udp.close()
