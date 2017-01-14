base:
  '*':
    - sp.essential.users.stefano

  'roles:spm-repo':
    - match: grain
    - sp.spm.repo.nginx

  'roles:redis':
    - match: grain
    - sp.redis
