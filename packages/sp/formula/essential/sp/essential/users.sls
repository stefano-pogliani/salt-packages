include:
  - users


sp-utils:
  pkg.installed:
    - names:
      - vim


sp-deluser-pi:
  user.absent:
    - name: pi
