base:
  '*':
    - sp.essential.users

  'roles:spm-repo':
    - match: grain
    - sp.spm.repo

  'roles:redis':
    - match: grain
    - sp.redis
