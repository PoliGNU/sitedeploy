# PoliGNU and PoliGEN Webserver deploy

PoliGNU and PoliGen are websites run in Drupal.

This cookbook aims to deploy them in an automated way.

Here is our infrastructure architecture:

![Infrastructure architecture](https://raw.github.com/PoliGNU/sitedeploy/master/doc/infra.png)

## Daily usage (after initial setup)

The main development functions are in the Rakefile (located at `cookbooks/polignu`). To check the options: `rake -T`.

Before commiting, remember to run the validations and tests:

    rake style
    rake integration[verify]
    rake smoke

## Development Environment Setup

### Pre-requisite softwares:

First install [VirtualBox](http://virtualbox.org),
[Vagrant](http://vagrantup.com),
[Bats](https://github.com/sstephenson/bats) and curl.

To install Bats (shell script testing tool):

```shell
$ git clone https://github.com/sstephenson/bats.git
$ cd bats
$ ./install.sh /usr/local
$ cd ..; rm -rf bats
```

### Ruby setup

See "[Ruby setup](https://github.com/PoliGNU/sitedeploy/blob/master/doc/ruby.md)".

### Downloading cookbooks upon which we depend

```
$ cd cookbooks/polignu
$ berks install
```

### Setup /etc/hosts

Add the following line to your `/etc/hosts`:

```
127.0.0.1  polignu.org poligen.polignu.org
```

## Understanding testing with kitchen

The usage of Kitchen is encapsulated in our Rakefile. 

But to better understand Kitchen, see "[Understanding testing with kitchen](https://github.com/PoliGNU/sitedeploy/blob/master/doc/kitchen.md)".


