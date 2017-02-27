sp-prometheus-server-dns:
  sp_pdns.record:
    - name: prometheus
    - zone: 'dyno.sph'
    - ttl:  3600
    - rtype: A
    - rvalue: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}
