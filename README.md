# docker-ike-vpn-client
IKEc vpn client based on the work of [Stono/ike](https://github.com/Stono/ike)

**NOTE:** currently not for production use, since no security considerations are made

General purpose IKEc client docker container, which allows SSH tunnels from your local host to a remote host.

## Build

    docker build -t ike-vpn-client .

## Run

    docker run -ti --rm --privileged -p 4122:22 --volume $(pwd)/sites:/sites --name vpn_mynet ike-vpn-client 'SITE_NAME' 'XAUTH_UN' 'XAUTH_PW'

The SITE_NAME is the VPN profile file containing:

    n:version:2
    s:network-host:124.0.45.32
    n:network-ike-port:500
    s:client-auto-mode:pull
    s:client-iface:virtual
    ...


## Tunnel
now you can create an SSH tunnel to a remote host, the password for the tunnel is always 'root'

### RDP
example for RDP:

    ssh -o PreferredAuthentications=password -L 192.168.31.10:33890:10.11.12.1:3389 -N root@localhost -p 4122

|                 |                          |
| --------------- |:------------------------:|
| local host IP:  | 192.168.31.10 (optional) |
| local host port:| 33890                    |
| remote host:    | 10.11.12.1               |
| remote port:    | 3389                     |


