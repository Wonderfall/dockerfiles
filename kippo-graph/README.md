### wonderfall/kippo-graph

![kippo-graph](https://github.com/ikoniaris/kippo-graph/blob/master/images/kippo-graph-img.png)

#### What is this?
Kippo-Graph is a full featured script to visualize statistics for a Kippo based SSH honeypot.

#### Environment variables
- **UID** *(default : 991)*
- **GID** *(default : 991)*

#### How to configure
You should provide your own configuration file from this base : https://github.com/ikoniaris/kippo-graph/blob/master/config.php.dist
You can mount this single file to your Docker container.

#### Docker compose (example)
```
kippo-graph:
  image: wonderfall/kippo-graph
  links:
    - cowrie-db:cowrie-db
  volumes:
    - /mnt/kippo-graph/config.php:/kippo-graph/config.php
    - /mnt/cowrie/log:/opt/cowrie/log
  environment:
    - GID=991
    - UID=991
```

