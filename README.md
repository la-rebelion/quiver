# Quiver by "La Rebelion"

1. [Install Kubernetes and Docker in Offline envs](https://rebelion.la/install-kubernetes-docker-offline)
2. [Kubernetes Security](https://rebelion.la/kubernetes-security-guide-to-penetration-testing): The Ultimate Guide to Penetration Testing and Best Practices for Securing Your Cluster

### Local Development

```
$ yarn start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

### Build

```
$ yarn build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

### Deployment

Using SSH:

```
$ USE_SSH=true yarn deploy
```

Not using SSH:

```
$ GIT_USER=<Your GitHub username> yarn deploy
```

If you are using GitHub pages for hosting, this command is a convenient way to build the website and push it to the `gh-pages` branch.

---

Docusaurus 2 [inclusion of a video file](https://stackoverflow.com/a/69193176/5078874) in a markdown file

## License

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Quiver by La Rebelion</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://rebelion.la" property="cc:attributionName" rel="cc:attributionURL">La Rebelion Labs</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/la-rebelion/quiver" rel="dct:source">https://github.com/la-rebelion/quiver</a>.