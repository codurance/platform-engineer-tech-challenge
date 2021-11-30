# Codurance Digital Platform Engineer Terraform challenge
The purpose of this test is for the engineer to demonstrate their thought
process when tackling a problem. It is not expected for the engineer to
complete the test in it's entirety, and the correctness of the solution is not
what's being assessed, rather the route taken to get to the problem will be what
the interviewers are looking at.

## The Setup
You will be provided with an instance in AWS running Nginx and SSH services 
running in an auto-scaling group, the terraform for which is in this repo.

## The Task
Using Terraform, your task is to scale up the instances in the ASG to 2 and add a load balancer, 
ensuring high availability. You should be able to visit the URL for the load 
balancer and successfully hit both instances. Demonstrate this by SSH-ing on to both instances
and showing the Nginx access logs.

## SSH Access
There is an SSH keypair in `bootstrap` called id_rsa.
