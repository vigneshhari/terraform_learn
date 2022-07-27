The current architecture utilises ECS to deploy applications with ease, ECS has a concept of tasks which contain the configuration to start containers, once the tasks are configured, we can start multiple tasks under the same task definition.

The ECS container is exposed via a load balancer that can only communiate to a given target port ( via a target group ), Only port 80 is exposed from the application, the LB exposes both 443 and 80 but because there is no SSL cert, 443 wont work as intended ( i did not include SSL because that might require some kind of validation and configuration change before execution )

The ECS cluster is deployed in a custom created VPC, the application servers are hosted in a private subnet and specific security groups are created to allow it to communicate with the LB and the internet via a NAT gateway.

The application hosted is a simple nginx image, this image does not have any dependencies. The application renders the default NGINX homepage in the root route.
