## wonderfall/ghost

![](https://i.goopics.net/lt.png)

#### What is this? What features?
- A **simple** Ghost CMS build made for production.
- It is based on Alpine Linux so it's lightweight.
- It uses node.js LTS (version check is disabled).
- Environment variables, thus providing basic flexibility.
- Offers Isso and Disqus basic support (casper).
- Offers syntax highlighting using [prism.js](http://prismjs.com/) (casper).

#### Build-time variables
- **VERSION** : version of Ghost.

#### Environment variables
- **GID** : ghost user id *(default : 991)*
- **UID** : ghost group id *(default : 991)*
- **SSL** : set to *True* if you use *https* on your blog. *(default : False)*
- **DOMAIN** : your domain (without *http(s)://*) *(default : my-ghost-blog.com)*
- **SYNTAX_HIGHLIGHTING** : enables syntax highlighting if set to *True* *(default : False)*
- **HIGHLIGHTER_COLOR** : color of syntax highlighting, *light* or *dark* *(default : light)*
- **CUSTOM_SMTP** : enables SMTP if set to *True* *(default : False)*
- **SMTP_PORT**, **SMTP_USER**, **SMTP_HOST** : SMTP settings
- **SMTP\_SENDER\_MAIL**, **SMTP\_SENDER\_NAME** : other SMTP settings
- **ENABLE_ISSO** : enables Isso support if set to *True* *(default : False)*
- **ISSO_HOST**, **ISSO_AVATAR**, **ISSO_VOTE** : Isso settings
- **ENABLE_DISQUS** : enables Disqus if set to *True* *(default : False)*
- **DISQUS_SHORTNAME** : your Disqus shortname

#### Volumes
- **/ghost/content** : contents of your blog, including themes

### Ports
- **2368** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)
