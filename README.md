# torify

This project uses tor as transparent proxy server.

## Example

First of all you need to create two wireguard files, one for the desktop and another one for the router:

wg-kali.conf
```
[Interface]
PrivateKey = yFhihHHIG9fpnQwqGQ0Z8cHcYGRjEUUMNLsFJf6m6EY=

[Peer]
PublicKey = Ge7VWCLVbc7mOCrVHEM/6Ubl4VFrAEdXDSJSOnMBfH8=
Endpoint = ROUTER:51820
AllowedIPs = 0.0.0.0/0
```

wg-router.conf
```
[Interface]
Address = 192.168.200.1/24
ListenPort = 51820
PrivateKey = gMQcxdgRcwmi6FDzp07S1M5t7h1e0c8WoXGEfuOSLXk=

[Peer]
PublicKey = fUcwp4+hS/WPZjrvcjf7ArPy5uMys2sBJcf+2AGqlzg=
AllowedIPs = 192.168.200.0/24
```

And also the docker-compose file.

docker-compose.yml
```
version: "2.3"
services:
  kali:
    image: ghcr.io/aluvare/kalidocker-vnc-lite/kalidocker-vnc-lite
    restart: always
    healthcheck:
      interval: 10s
      retries: 12
      test: nc -vz 127.0.0.1 5900
    cap_add:
      - NET_ADMIN
    volumes:
     - /dev/net/tun:/dev/net/tun
     - ./wg-kali.conf:/etc/wireguard/wg-template.conf:ro
    environment:
      - "PRECOMMAND=cmlwPSQoaG9zdCByb3V0ZXJ8YXdrICJ7cHJpbnQgXCRORn0iKTtzZWQgInMvUk9VVEVSLyR7cmlwfS9nIiAvZXRjL3dpcmVndWFyZC93Zy10ZW1wbGF0ZS5jb25mID4gL2V0Yy93aXJlZ3VhcmQvd2cuY29uZjt3aXJlZ3VhcmQtZ28gd2cgJiYgaXAgYWRkcmVzcyBhZGQgZGV2IHdnIDE5Mi4xNjguMjAwLjIvMjQgJiYgd2cgc2V0Y29uZiB3ZyAvZXRjL3dpcmVndWFyZC93Zy5jb25mICYmIGlwIGxpbmsgc2V0IHVwIGRldiB3ZztpcCByb3V0ZSBkZWxldGUgZGVmYXVsdDtpcCByb3V0ZSBhZGQgZGVmYXVsdCB2aWEgMTkyLjE2OC4yMDAuMTsgc2xlZXAgMTAgJiYgZWNobyBkMmhwYkdVZ2RISjFaVHRrYnlCbmNtVndJQ0p1WVcxbGMyVnlkbVZ5SWlBdlpYUmpMM0psYzI5c2RpNWpiMjVtSUh4M2FHbHNaU0J5WldGa0lHazdaRzhnSUdsbUlGdGJJQ0lrYVNJZ0lUMGdJakU1TWk0eE5qZ3VNakF3TGpFaUlGMWRPM1JvWlc0Z1pXTm9ieUFpYm1GdFpYTmxjblpsY2lBeE9USXVNVFk0TGpJd01DNHhJaUErSUM5bGRHTXZjbVZ6YjJ4MkxtTnZibVk3SUdacE95QmtiMjVsTzNOc1pXVndJREU3Wkc5dVpRbz18YmFzZTY0IC1kfGJhc2ggJgo="
    depends_on:
      - router
  novnc:
    image: ghcr.io/aluvare/easy-novnc/easy-novnc
    restart: always
    depends_on:
      - kali
    command: --addr :8080 --host kali --port 5900 --basic-ui --no-url-password --novnc-params "resize=remote"
    ports:
      - "8080:8080"
  router:
    image: ghcr.io/aluvare/torify/torify
    restart: always
    cap_add:
      - NET_ADMIN
    volumes:
     - /dev/net/tun:/dev/net/tun
     - ./wg-router.conf:/etc/wireguard/wg.conf:ro
```

And now, just open chrome (best for clipboard synchronization), and navigate to 127.0.0.1:8080
