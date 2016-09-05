NGINX install/configuration SPM package
=======================================
An SPM package to install and configure NGINX.


Available states
----------------
The following states are available to include:

  * `sp.nginx`: Install and configure nginx based on pillar data.
    See `pillar.example` for a details of available options.
  * `sp.nginx.install`: Install nginx as instructed by pillar `sp:nginx:install_from`.
  * `sp.nginx.configure`: Deploy the main nginx configuration.
  * `sp.nginx.service`: Ensure the nginx service is running.


State modules
-------------
The package also deploys an `nginx_vhost` state module that provides the
following states:

### `nginx_vhost.absent`
Ensures that a virtual host is not present on the system.
Attributes are:

  * `name`: used to identify the virtual host to remove.

### `nginx_vhost.managed`
Ensures that a virtual host is present on the system.
Attributs are:

  * `name`: used to identify the virtual host.
  * `source`: the source URL to fetch the vhost definition from.
