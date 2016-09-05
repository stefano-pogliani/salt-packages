# Default nginx install and configuration.
# If the pillar options (see pillar.example) are too limitied
# do not use this state directly but pick and mix the specific states
# that suite you and build your own to integrate.
include:
  - sp.nginx.install
  - sp.nginx.configure
  - sp.nginx.service
