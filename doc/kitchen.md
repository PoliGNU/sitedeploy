# Understanding testing with kitchen

The usage of Kitchen is encapsulated in our Rakefile. 
But to better understand Kitchen, here goes some further explanation.

To run the test suit:

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

Obs: kitchen commands must be run within the `cookbooks/polignu` folder.

