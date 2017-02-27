include:
  - sp.app.grafana.install
  - sp.storage.nfs.client


sp-grafana-datardir:
  file.directory:
    - name: '/data/grafana'
    - group: 'nfs_grafana'
    - user:  'nfs_grafana'
    - mode:  '0755'

    - require:
      - pkg: sp-grafana-pkg
      - group: sp-nfs-group-grafana
      - user: sp-nfs-user-grafana


sp-grafana-nfs-mount:
  mount.mounted:
    - name: '/data/grafana'
    - device: 'lon01-lef0:/data/nfs/grafana'
    - fstype: 'nfs4'
    - dump: 0
    - pass_num: 0
    - persist: true
    - opts:
      - _netdev
      - hard

    - require:
      - file: sp-grafana-datardir
