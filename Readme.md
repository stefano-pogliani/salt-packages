SaltStack Packages
==================
A set of packages to run my personal SaltStack deployment.
Based on salt packages, automated through `make` and my `salt-tools`.


Build a package
---------------
```bash
make build PACKAGE=<NAME>
ll out/<NAME>*
```

### Community packages without FORMULA file
???


Running tests
-------------
Tests are run in kithen.
Use https://github.com/stefano-pogliani/salt-tools to set up the environment.

Some tests require extra helpers which are provided by the `sp-test` formula.
Support for GPG encoded data is hacked in by adding this to `.kithen.yml`:
```yaml
  pillars-from-files:
    # Hack to inject gpgkeys.
    ../../../../etc/salt/gpgkeys/random_seed: test/integration/gpgkeys/random_seed
    ../../../../etc/salt/gpgkeys/pubring.gpg: test/integration/gpgkeys/pubring.gpg
    ../../../../etc/salt/gpgkeys/secring.gpg: test/integration/gpgkeys/secring.gpg
    ../../../../etc/salt/gpgkeys/trustdb.gpg: test/integration/gpgkeys/trustdb.gpg
```

See `packages/sp/formula/essential` for example kitchen configuration.
Use `make test PACKAGE=...` or `make kitchen PACKAGE=... ACTION=...`
as shorthands for activating the kitchen environment and running commands
from the correct directory.
