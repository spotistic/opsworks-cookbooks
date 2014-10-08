opsworks_rubber
====================

This cookbook sets up an [AWS OpsWorks](http://aws.amazon.com/opsworks/) instance to run [sidekiq](http://sidekiq.org/) for a [Rubber](https://github.com/spotistic/backend-rubber) application.

This cookbook uses upstart to manage 1 or more Sidekiq *processes* per machine (1 per CPU).

Prerequisites
-------------

Assumes you have redis installed, configured and the connection with sidekiq established. This does not handle any redis connection setup.

Configuration Examples
----------------------

By default, no sidekiq processes will be started.

### Custom JSON

JSON such as the following added as custom JSON to the stack:

```json
{
  "rubber": {
    "config" : {
      "concurrency": 5,
      "verbose": false,
      "queues": ["critical", "default", "low"]
    }
  }
}
```

Will result in upstart managed sidekiq *processes*. It will create a file `config/rubber.yml` containing the yaml representation of the contents of the config JSON object. In this case the `config/rubber.yml` would look like:

```yaml
:concurrency: 5
:verbose: false
:queues
  - critical
  - default
  - low
```

By just converting your JSON config object to yaml we support any plugins that use sidekiq.yml.

### 'Wrapper/Layer' Cookbooks

For more fine grained control and less brittle JSON configuration it is suggested to use wrapper/layer recipes and override attributes in it.

OpsWorks Set-Up
---------------

The layer's custom chef recipes should be associated with events as follows:

* **Setup**: `opsworks_rubber::setup`
* **Configure**: `opsworks_rubber::configure`
* **Deploy**: `opsworks_rubber::deploy`
* **Undeploy**: `opsworks_rubber::undeploy`
* **Shutdown**: `opsworks_rubber::stop`


Logging
-------

Logging is done with syslog. Check the logs with:

```
sudo tail -f /var/log/syslog | grep rubber
```

License
-------

See [LICENSE](LICENSE).
