
# Staging

Testing with a VM running in your localhost has some drawbacks since the VM is not Internet available. 

The main drawback is that it's not possible to verify the integration with the Let's Encrypt service.

Another drawback is that Kitchen make some stuff to make your life easier... but in production you will have not Kitchen. So it's necessary to rehearsal the whole process in a staging environment.

## How to

Create an Internet accessible VM. It can something like Amazon EC2 or Dream Host.

Obs: if you are using Amazon EC2, you need to enable DNS hostnames: http://stackoverflow.com/questions/20941704/ec2-instance-has-no-public-dns

SSH into your VM and clone the repo on the home folder.

```
git clone https://github.com/PoliGNU/sitedeploy.git
```

Bootstrap the node by running `bootstrap_node.sh`. I do not know why, but simply running the script does not work. It's better to run command by command. It seems to be related with the `source ~/.bashrc` line.

Since the bootstrap takes some time, after this step I advice you to take a snapshot or create an image based on the VM current state.

Edit the node.json. In the `environment` property, set `staging`. In the `server_name` property, set the DNS hostname of your VM.

Now you can run Chef (on sitedeploy folder):

```
sudo chef-solo -c solo.rb
```





