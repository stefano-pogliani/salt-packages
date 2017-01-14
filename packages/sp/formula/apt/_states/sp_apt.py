from os import path

from salt import loader


APT_PREF_PATH = '/etc/apt/preferences.d'


def _pin_name(name):
    return path.join(APT_PREF_PATH, name)


def packages_from(name=None, packages=None, release=None, priority=1000):
    """Pins packages to an apt release.

    :param str name: The name of the pin file.
    :param str|[str] packages: List of or single package glob to pin.
    :param str release: The release to pin to.
    :param int priority: The pin priority for the packages.
    """
    result = {}
    result['name'] = name

    # Packages to pin.
    if isinstance(packages, list):
        packages = ', '.join(packages)

    args = {
            'name': _pin_name(name),
            'group': 'root',
            'mode':  '0640',
            'user':  'root',
            'contents': '\n'.join([
                'Package: ' + packages,
                'Pin: release a=' + release,
                'Pin-Priority: {0}'.format(priority)
            ])
    }

    __states__ = loader.states(__opts__, __salt__, None, None)
    __states__['file.managed'].func_globals['__env__'] = __env__
    __states__['file.managed'].func_globals['__instance_id__'] = __instance_id__
    file_result = __states__['file.managed'](**args)

    for attr in ('result', 'changes', 'comment'):
        result[attr] = file_result[attr]
    return result
