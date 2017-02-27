base:
  '*':
    - sp.essential.users


  'lon01-lef0':
    - sp.storage.lvm2
    - sp.storage.mounts
    - sp.storage.nfs.server

    - sp.app.prometheus.server
    - sp.app.prometheus.dns_name
    - sp.app.prometheus.node_exporter


  'lon01-lef1':
    - sp.spm.repo
    - sp.powerdns
    - sp.powerdns.config
    - sp.powerdns.dyno_zone
    - sp.storage.nfs.client

    - sp.app.grafana
    - sp.app.prometheus.node_exporter


  'lon01-cam01':
    - sp.app.prometheus.node_exporter
