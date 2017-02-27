include:
  - sp.powerdns


sp_dyno_zone:
  sp_pdns.zone:
    - name: 'dyno.sph.'
    - pdns_address: 'http://127.0.0.1:8081'
    - nameservers:
      - 'ns1.dyno.sph.'

    - require:
      - service: sp-powerdns


sp_dyno_pdns:
  sp_pdns.record:
    - name: pdns
    - zone: 'dyno.sph'
    - ttl:  3600
    - rtype: A
    - rvalue: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}
    - pdns_address: 'http://127.0.0.1:8081'

    - require:
      - sp_pdns: sp_dyno_zone


sp_dyno_ns1:
  sp_pdns.record:
    - name: ns1
    - zone: 'dyno.sph'
    - ttl:  3600
    - rtype: A
    - rvalue: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}

    - require:
      - sp_pdns: sp_dyno_zone
      - sp_pdns: sp_dyno_pdns


sp_dyno_salt:
  sp_pdns.record:
    - name: salt
    - zone: 'dyno.sph'
    - ttl:  3600
    - rtype: A
    - rvalue: {{ salt['grains.get']('ip4_interfaces:eth0')[0] }}

    - require:
      - sp_pdns: sp_dyno_zone
      - sp_pdns: sp_dyno_pdns
