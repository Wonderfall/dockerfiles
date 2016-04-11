## wonderfall/ghost
**SIZE = ±188MB**

![](https://i.goopics.net/lt.png)

#### What is this?
- A **simple** Ghost CMS build made for production.
- It is based on Alpine Linux so it's lightweight.
- It uses node.js 5.x (version check is disabled).
- Environment variables for basic flexibility.

#### Environment variables
- **SSL** : set to *True* if you use https on your blog.
- **DOMAIN** : your domain without http(s)://
- **GID** : ghost user id.
- **UID** : ghost group id.
- **CUSTOM_SMTP** : enable SMTP if set to *True*
- **SMTP_PORT**, **SMTP_USER**, **SMTP_HOST**
- **ENABLE_ISSO** : enable Isso support if set to *True*
- **ISSO_HOST**, **ISSO_AVATAR**, **ISSO_VOTE**

#### Volumes
- **/ghost/content** : contents of your blog, including themes
