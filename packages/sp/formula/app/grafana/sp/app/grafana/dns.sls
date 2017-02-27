sp-grafana-dns:
  sp_pdns.record:
    - name: grafana
    - zone: 'dyno.sph'
    - ttl:  3600
    - rtype: A
    - rvalue: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}
