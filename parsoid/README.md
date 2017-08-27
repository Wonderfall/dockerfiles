## wonderfall/parsoid

#### What is this? What features?
- A **simple** Parsoid image.
- Based on Alpine Linux so it's lightweight!
- Bundled with latest node.js available (version check is disabled).

#### Build-time variables
- **VERSION** : version of Ghost.

#### Environment variables
- **GID** : ghost user id *(default : 991)*
- **UID** : ghost group id *(default : 991)*
- **ADDRESS** : your address *(default : http://localhost/w/)*
- **DOMAIN** : name of the container *(default : localhost)*

### docker-compose.yml sample

```
mywiki-parsoid:
  image: wonderfall/parsoid
  container_name: mywiki-parsoid
  environment:
     - UID=1669
     - GID=1669
     - ADDRESS=https://wiki.domain.com/
     - DOMAIN=mywiki-parsoid
```
