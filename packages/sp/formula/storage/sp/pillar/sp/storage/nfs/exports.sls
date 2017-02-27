sp:
  nfs:
    exports:
      - name:  grafana
        group: grafana
        user:  grafana

        allowed_host: 'lon01-lef1'
        options:
          - mountpoint=/data
          - no_subtree_check
          - no_root_squash
          - rw
          - sync
          # User mapping does not work and groups do not work either.
          # Since each export has a purpouse and a server, squash
          # everything to the grafana user.
          - all_squash
          - anonuid=4001
          - anongid=4001
