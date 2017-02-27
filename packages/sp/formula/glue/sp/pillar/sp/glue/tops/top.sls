base:
  '*':
    - sp.essential.users.stefano
    - sp.powerdns

    - sp.secrets.powerdns


  'lon01-lef0':
    - sp.storage.mounts
    - sp.storage.nfs.exports
    # Import all NFS users on the server.
    - sp.storage.nfs.users.grafana


  'lon01-lef1':
    - sp.spm.repo.nginx
    # Import needed NFS user.
    - sp.storage.nfs.users.grafana

  'lon01-cam01':
    - sp.app.prometheus.armv6
