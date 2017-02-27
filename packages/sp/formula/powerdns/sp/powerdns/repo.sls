sp_powerdns_server_repo:
  pkgrepo.managed:
    - humanname: PowerDNS
    - name: deb https://repo.powerdns.com/raspbian {{ salt['grains.get']('oscodename') }}-auth-40 main
    - file: /etc/apt/sources.list.d/powerdns.list
    - keyid: FD380FBB
    - keyserver: keys.gnupg.net
