import logging
import requests
from os import path


log = logging.getLogger(__name__)


class PDnsClient(object):
    """Wrapper around PowerDNS API."""
    def __init__(self, address, key):
        self._address = address
        self._key = key.strip()

    def _get(self, uri):
        url = self._address + uri
        headers = {'Accept': 'application/json', 'X-API-Key': self._key}
        return requests.get(url, headers=headers)

    def _patch(self, uri, data):
        url = self._address + uri
        headers = {'Accept': 'application/json', 'X-API-Key': self._key}
        return requests.patch(url, headers=headers, json=data)

    def _post(self, uri, data):
        url = self._address + uri
        headers = {'Accept': 'application/json', 'X-API-Key': self._key}
        return requests.post(url, headers=headers, json=data)

    def create_zone(self, **kwargs):
        return self._post('/api/v1/servers/localhost/zones', kwargs)

    def record(self, zone, name, rtype):
        zone_info = self.zone(zone)
        if zone_info.status_code != 200:
            return None
        return [
            rd for rd in zone_info.json().get('rrsets', [])
            if rd['name'] == name and rd['type'] == rtype
        ]

    def replace_record(self, zone, name, rtype, values, ttl):
        data = {}
        records = [{
            'content': value,
            'disabled': False
        } for value in values]
        data['rrsets'] = [{
            'name': name,
            'type': rtype,
            'ttl':  ttl,
            'changetype': 'REPLACE',
            'records': records
        }]
        return self._patch('/api/v1/servers/localhost/zones/' + zone, data)

    def zone(self, name):
        return self._get('/api/v1/servers/localhost/zones/' + name)


def _client(pdns_address, pdns_key):
    """Create a client with the correct address and key"""
    if pdns_address is None:
        pdns_address = __salt__['pillar.get']('sp:powerdns:address')
    if pdns_key is None:
        pdns_key = __salt__['pillar.get']('sp:powerdns:api_key')

    log.debug('PowerDNS address: %s', pdns_address)
    return PDnsClient(pdns_address, pdns_key)


def record(
        name, zone=None, rtype=None, rvalue=None, ttl=None,
        purge=False, pdns_address=None, pdns_key=None
):
    """
    Creates/updates a DNS record.

    If the record is present and has multiple values,
    all values are overwritten by the specified rvalue.

    rvalue can be a list of values.
    """
    result = {
        'name': name,
        'changes': None,
        'result': True,
        'comment': 'Record already exists'
    }

    # Validate arguments.
    args = (
            ('zone', zone), ('rtype', rtype),
            ('rvalue', rvalue), ('ttl', ttl)
    )
    for (arg_name, arg) in args:
        if arg is None:
            result['result'] = False
            result['comment'] = 'Argument {0} is required'.format(arg_name)
            return result

    name = '{0}.{1}'.format(name, zone)
    if name[-1] != '.':
        name += '.'

    values = [rvalue]
    if isinstance(rvalue, list):
        values = rvalue

    # Check record status.
    changes = {}
    client = _client(pdns_address, pdns_key)
    record = client.record(zone, name, rtype)

    # Validate record.
    if record:
        record = record[0]
        old_ttl = record['ttl']
        old_values = [
            rd['content'] for rd in record['records']
        ]
        if old_ttl == ttl and old_values == values:
            return result

        # Update changes and, later, the record.
        if old_ttl != ttl:
            changes['ttl'] = {'old': old_ttl, 'new': ttl}
        if old_values != values:
            changes['records'] = {'old': old_values, 'new': values}

    else:
        changes['ttl'] = {'old': '', 'new': ttl}
        changes['records'] = {'old': '', 'new': values}

    # If testing bail now.
    if __opts__['test']:
        result['result'] = None
        result['changes'] = changes
        result['comment'] = 'Would create/update {0} record {1}.{2}'.format(
                rtype, name, zone
        )
        return result

    # Record does not exists or it is not up to date.
    new_record = client.replace_record(zone, name, rtype, values, ttl)

    if new_record.status_code < 400:
        result['result'] = True
        result['changes'] = changes
        result['comment'] = 'Record created/updated'
        return result

    # Request failed.
    record_data = new_record.json()
    error = record_data.get('error', 'Something went wrong')
    comment = '[HTTP/{0}] {1}'.format(new_record.status_code, error)
    result['result'] = False
    result['comment'] = comment
    return result


def zone(
        name, dnssec=True, soa_edit=None, soa_edit_api=None,
        nameservers=[], pdns_address=None, pdns_key=None
):
    """
    Ensures a zone exists or creats it (if missing).
    """
    result = {
        'name': name,
        'changes': None,
        'result': True,
        'comment': 'Zone already exists'
    }

    # Check if the zone exists.
    client = _client(pdns_address, pdns_key)
    info = client.zone(name)
    if info.status_code == 200:
        log.info('Zone "%s" already exists', name)
        return result

    # It does not, create it.
    changes = {
        'zone_name': {'old': '', 'new': name}
    }
    log.info('Creating zone %s', name)
    if __opts__['test']:
        result['result'] = None
        result['changes'] = changes
        result['comment'] = 'Would create zone {0}'.format(name)
        return result

    new_zone = client.create_zone(
            name=name, dnssec=dnssec, soa_edit=soa_edit,
            soa_edit_api=soa_edit_api, nameservers=nameservers,
            kind='Native'
    )
    zone_data = new_zone.json()
    if new_zone.status_code < 400:
        zid = zone_data['id']
        result['result'] = True
        result['changes'] = changes
        result['comment'] = 'Zone created with ID {0}'.format(zid)
        return result

    # Request failed.
    error = zone_data.get('error', 'Something went wrong')
    comment = '[HTTP/{0}] {1}'.format(new_zone.status_code, error)
    result['result'] = False
    result['comment'] = comment
    return result
