test-redis-from:
  sp_apt.packages_from:
    - name: redis
    - packages: 'redis-*'
    - release:  'testing'
