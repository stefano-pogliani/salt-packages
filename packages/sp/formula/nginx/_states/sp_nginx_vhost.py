from os import path

from salt import loader


def _lookup_arg(argument, kwargs, default, pillar_arg=None):
    pillar_arg = argument if pillar_arg is None else pillar_arg
    return kwargs.get(argument, __salt__['pillar.get'](
        'sp:nginx:lookup:' + pillar_arg, default
    ))

def _vhost_name(name):
    nginx_conf = __salt__['pillar.get'](
            'sp:nginx:conf_path', '/etc/nginx/conf.d'
    )
    return path.join(nginx_conf, 'vhost-' + name + '.conf')


def absent(name=None, **kwargs):
    result = {}
    result['name'] = name

    args = {}
    args.update(kwargs)
    args['name']  = _vhost_name(name)

    __states__ = loader.states(__opts__, __salt__, None, None)
    __states__['file.absent'].func_globals['__env__'] = __env__
    __states__['file.absent'].func_globals['__instance_id__'] = __instance_id__
    file_result = __states__['file.absent'](**args)

    for attr in ('result', 'changes', 'comment'):
        result[attr] = file_result[attr]
    return result

def present(name=None, **kwargs):
    result = {}
    result['name'] = name

    args = {}
    args.update(kwargs)
    args['name']  = _vhost_name(name)
    args['user']  = _lookup_arg('user', kwargs, 'www-data')
    args['group'] = _lookup_arg('group', kwargs, 'www-data')
    args['mode']  = _lookup_arg('mode', kwargs, 644)

    __states__ = loader.states(__opts__, __salt__, None, None)
    __states__['file.managed'].func_globals['__env__'] = __env__
    __states__['file.managed'].func_globals['__instance_id__'] = __instance_id__
    file_result = __states__['file.managed'](**args)

    for attr in ('result', 'changes', 'comment'):
        result[attr]  = file_result[attr]
    return result
