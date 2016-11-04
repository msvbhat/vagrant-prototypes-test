# vagrant-prototypes

This repo contains few sample projects related to vagrant while exploring more about vagrant technology

# vagrant-aws

This helps you launch an AWS EC2 instance and runs http server using docker provisioner.

## Requirements

### System requirements
    * vagrant 1.2+ package installed on your laptop or host machine. Please consult https://www.vagrantup.com/docs/installation/
    * vagrant-aws plugin installed on your laptop or host machine. You can run `vagrant plugin install vagrant-aws` to install it.
    * You host machine should have rsync installed. This is because we sync folders using rsync

### Other Requirements
    * You should have access to an AWS account and should have permissions to launch an EC2 instance.
    * This assumes that the AMI launched has docker pre-installed in them and doesn't install any specific version of them.

## Usage

Assuming that you have cloned this repo or extracted the tarball, Please `cd` to directory which contains the `Vagrantfile` and run `vagrant up --provider=aws`.
But this `Vagrantfile` expects few environment variables to lauch the ec2 instance.

* *AWS_ACCESS_KEY* - This is the [AWS access key ID](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-environment) which you generated. For how to generate it please check [this link](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)
* *AWS_SECRET_KEY* - This is the [AWS secret key ID](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-environment) which you generated. For how to generate it please check [this link](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)
* *AWS_REGION* - The region where EC2 instance should run. For example 'us-east-1' or 'eu-central-1'
* *AWS_AMI_ID* - This is the AMI ID which contains the base image for the OS. Note that AMI ID will be different in different regions even if OS are same.
* *AWS_KEYPAIR* - The ssh keypair used to login into the launched instance via ssh. Note that this keypair should be present in the *AWS_REGION* specified above. To generate a new keypair please check [this link](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair).
* *AWS_SECURITY_GROUP* - This is the AWS Security Group name. Note that vagrant uses SSH to access the launched instance. So the security group should allow incoming traffic on port 22 from your laptop. If you have an existing SG in the same reqion which allows this ssh traffic you can provide the same here. For more information about how to create a new security group please check [this link](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html#creating-security-group).
* *AWS_SSH_PEM_KEY* - This is the path to the ssh pem key (or keypair generated above). This is used by vagrant to get ssh access to the instance.

Once you have above env variables exported, you can run the `vagrant up --provider=aws` command to launch the instance.

```bash
    cd vagrant-prototypes-test
    export AWS_ACCESS_KEY=<access key>
    export AWS_SECRET_KEY=<secret key>
    export AWS_REGION='us-west-X'
    export AWS_AMI_ID='ami-XXXXX'
    export AWS_KEYPAIR='name of keypair'
    export AWS_SECURITY_GROUP='name of AWS security group'
    export AWS_SSH_PEM_KEY='/path/to/pem/key'
    vagrant up --provider=aws
```

This Vagrantfile launches the ec2 instance with the information provided above and syncs the current directory to remote ec2 instance. Then it uses [docker provisioner]() to build an image from the Dockerfile and run them by binding it to the port 80 of the host ec2 instance. The docker container will just run the apache http server without any modification. So when you access host instance IP, it will server default ubuntu apache homepage.

You can check if everything is successful by entering the public IP of the instance in browser or by using the below wget command.

```bash
    wget -qO- <public IP of the launched instance>
```

You can go to the AWS web console to get the public IP or public DNS of the instance.


### Few things to note
    * It is very important that the vagrant has ssh access to the instance. So keypair, ssh pem key and security group should be configured accordingly. Wrong configuration of any one of these will result in failure or hang.
    * We do not launch it in a VPC. So if you have a new AWS account this will be launched in default VPC.
    * Since we sync the `.` folder, you should cd into this directory before running any command.
    * We do not install docker on remote machines. So please make sure that you launch an AMI which contains docker pre-installed. (Or images like CoreOS)

For any issues, please open an github issue.
