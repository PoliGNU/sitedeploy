# PoliGNU and PoliGEN Webserver deploy

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

Install `rbenv`, a tool to manage the installed Ruby versions.

A way to install rbenv (based on https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04):

```shell
$ sudo apt update
$ sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
```

But you can install in other ways. In Arch it's possible to use the AUR package.

After installing rbenv:

```shell
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ source ~/.bashrc
```

You can check to see if rbenv was set up properly by using the `type` command,
which will display more information about rbenv:

```shell
$ type rbenv
```

Your terminal window should output the following:

    Output
    rbenv is a function
    rbenv ()
    {
        local command;
        command="$1";
        if [ "$#" -gt 0 ]; then
            shift;
        fi;
        case "$command" in
            rehash | shell)
                eval "$(rbenv "sh-$command" "$@")"
            ;;
            *)
                command rbenv "$command" "$@"
            ;;
        esac
    }

In order to use the `rbenv install` command, which simplifies the installation
process for new versions of Ruby, you should install
[ruby-build](https://github.com/rbenv/ruby-build), which we will install as a
plugin for rbenv through git:

```shell
$ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

In Arch Linux, it's possible to install ruby-build using the AUR package.

Now, let's install Ruby:

```shell
$ rbenv install 2.3.3
$ rbenv global 2.3.3
```

The *global* command sets the default Ruby version in the system.

Verify that Ruby was properly installed by checking your version number:

```shell
$ ruby -v
```

### Working with Gems

Gems are packages that extend the functionality of Ruby.

We declares the gems we are going to use in the Gemfile. To be able to use the Gemfile, we need the Bundler gem.
Bundler manages application dependencies.

```shell
$ gem install bundler
```

You can use the `gem env` command (the subcommand env is short for
`environment`) to learn more about the environment and configuration of gems.

Being on the root folder of this repository, run the following command to
install our ruby-based dependencies:

```shell
$ bundle install
```

## Testing (with kitchen)

To run the test suit, you should run the following command:

```kitchen test```

`kitchen` will use the `Vagrant` to create a VirtualMachine (VM) and will
execute the tests inside this VM using the
`[Servspec](http://serverspec.org/)`.

After a successful test, the VM is destroyed. If the test has failed, then the
VM is kept, as is, so you can take a look on what went wrong.

To login on the VM, run:

```kitchen login```

To destroy the VM, run:

```kitchen destroy```

To test without destroying the VM, even if the test was successful, run:

```kitchen verify```

Using the `verify` is a good idea to speed up the dev-test cycle, avoiding the
need to wait the VM creating. Off course that depending on the recepie changes,
the recreation of the VM may be necessary.

The states of a kitchen created VM can be:
* `created`: VM created with Vagrant;
* `converged`: Chef executed on the VM;
* `verified`: Tests executed.

To verify the VM status, run:

```kitchen list```
