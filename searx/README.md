## hoellen/searx

![](https://i.goopics.net/ls.png)

#### What is searx?
Searx is a metasearch engine, inspired by the seeks project.
It provides basic privacy by mixing your queries with searches on other platforms without storing search data. Queries are made using a POST request on every browser (except chrome*). Therefore they show up in neither our logs, nor your url history. In case of Chrome* users there is an exception, Searx uses the search bar to perform GET requests. Searx can be added to your browser's search bar; moreover, it can be set as the default search engine.

#### Features
- Based on Alpine Linux.
- Based on discontinued wonderfall/searx (thanks!).
- Latest code from [asciimoo/searx](https://github.com/asciimoo/searx)
- A unique secret key is generated when booting the first time.

#### Tags
- **latest** : latest stable version (0.15)
- **master** : latest code from master branch

`latest` and `master` are built weekly. For security reasons, you should occasionally update the container, even if you have the latest version of Searx.

#### Build-time variables
- **VERSION** : Searx version

#### Environment variables
- **IMAGE_PROXY** : enables images proxying *(default : False)*
- **BASE_URL** : http://domain.tld *(default : False)*

#### Ports
- **8888** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration)
