Vagrant LAMP
============

My default LAMP development stack configuration for Vagrant.
This is the PHP 5.5/Apache 2.4 version based on Ubuntu 14.04 (Trusty Tahr).

Installation:
-------------

Download and install [VirtualBox](http://www.virtualbox.org/)

Download and install [vagrant](http://vagrantup.com/)

Optionally, install the [vagrant persistent storage plugin](https://github.com/kusnier/vagrant-persistent-storage)

    $ vagrant plugin install vagrant-persistent-storage

Download a vagrant box (name of the box is supposed to be precise32)

    $ vagrant box add precise32 http://files.vagrantup.com/precise32.box

Clone this repository

Go to the repository folder and launch the box

    $ cd [repo]
    $ vagrant up

What's inside:
--------------

Installed software:

* Apache
* MySQL (will use persistent storage if you installed the plugin above, so you
  can safely destroy the box)
* php
* phpMyAdmin
* Xdebug with Webgrind
* zsh with [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* git, subversion
* mc, vim, screen, tmux, curl
* [MailCatcher](http://mailcatcher.me/)
* [Composer](http://getcomposer.org/)
* Phing
* Drupal utils:
    * [Drush](http://drupal.org/project/drush)
* Wordpress utils:
    * [WP-Cli](http://wp-cli.org/)
    * [wp2github.py](http://github.com/r8/wp2github.py)
* Magento utils:
    * [n98-magerun](https://github.com/netz98/n98-magerun)
    * [modman](https://github.com/colinmollenhour/modman)
    * [modgit](https://github.com/jreinke/modgit)
* Node.js with following packages:
    * [CoffeeScript](http://coffeescript.org)
    * [Grunt](http://gruntjs.com/)
    * [Bower](http://bower.io)
    * [Yeoman](http://yeoman.io)
    * [LESS](http://lesscss.org)
    * [CSS Lint](http://csslint.net)

Notes
-----

### Apache virtual hosts

You can add virtual hosts to apache by adding a file to the `data_bags/sites`
directory. The docroot of the new virtual host will be a directory within the
`public/` folder matching the `host` you specified. Alternately you may specify
a docroot explicitly by adding a `docroot` key in the json file.

### MySQL

The guests local 3306 port is available on the host at port 33066. It is also available on every domain. Logging in can be done with username=root, password=vagrant.

### phpMyAdmin

phpMyAdmin is available on every domain. For example:

    http://local.dev/phpmyadmin

### XDebug and webgrind

XDebug is configured to connect back to your host machine on port 9000 when
starting a debug session from a browser running on your host. A debug session is
started by appending GET variable XDEBUG_SESSION_START to the URL (if you use an
integrated debugger like Eclipse PDT, it will do this for you).

XDebug is also configured to generate cachegrind profile output on demand by
adding GET variable XDEBUG_PROFILE to your URL. For example:

    http://local.dev/index.php?XDEBUG_PROFILE

Webgrind is available on each domain. For example:

    http://local.dev/webgrind

It looks for cachegrind files in the `/tmp` directory, where xdebug leaves them.

**Note:** xdebug uses the default value for xdebug.profiler_output_name, which
means the output filename only includes the process ID as a unique part. This
was done to prevent a real need to clean out cachgrind files. If you wish to
configure xdebug to always generate profiler output
(`xdebug.profiler_enable = 1`), you *will* need to change this setting to
something like

    xdebug.profiler_output_name = cachegrind.out.%t.%p

so your call to webgrind will not overwrite the file for the process that
happens to serve webgrind.

### Mailcatcher

All emails sent by PHP are intercepted by MailCatcher. So normally no email would be delivered outside of the virtual machine. Instead you can check messages using web frontend for MailCatcher, which is running on port 1080 and also available on every domain:

    http://local.dev:1080

### Composer

Composer binary is installed globally (to `/usr/local/bin`), so you can simply call `composer` from any directory.

### Updating recipes

Please note that for normal use, it is not needed to take the following steps.
You will only need this if, for some reason, you want to update the cookbooks.
This will usually only be the case if you maintain your own fork of
vagrant-lamp. Also **do not** attempt to do this if you are not doing it from a
Git clone. We rely on the git history to restore some files in the final step.

The repository contains a Berkfile that can be used to fetch the latest versions
of all the required recipes in a manner that ensures (assuming all cookbooks
list their own dependencies correctly) they will work correctly together. For
this to work, you will need [berkshelf](http://berkshelf.com) installed. The
easiest way to do that is to install
[Chef-DK](http://getchef.com/downloads/chef-dk).

When you have the berks command available, first remove the cookbooks directory
and any Berksfile.lock files:

    $ rm -Rf cookbooks
    $ find . -name Berksfile.lock -exec rm {} \;

After having removed the old cookbooks, run berks with the Berksfile, telling it
to put the cookbooks in the cookbooks directory:

    $ berks vendor cookbooks

Now, we have a small problem left to resolve; by removing the cookbooks
directory (which was needed to allow berks to re-create if with all the latest
and greatest cookbooks) we also removed the vagrant_main cookbook, which is
custom for our project, so we need to ask git to restore it.

    $ git checkout HEAD -- cookbooks/vagrant_main/

Done and done. You probably want to inspect the changes and check in the changed
cookbooks into Git.
