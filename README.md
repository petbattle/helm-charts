# 🍾 petbattle helm charts 🍾
```
helm repo add petbattle https://petbattle.github.io/helm-charts
```

![Pump It Up](https://i.pinimg.com/originals/c4/43/fc/c443fcf40abba3f9e098d5bd25ca20be.gif)

## Deploying Pet Battle using helm3

Login to OpenShift as cluster admin user

Create a project
```bash
oc new-project pb
```
Install the full Pet Battle suite of apps
```bash
helm repo add petbattle https://petbattle.github.io/helm-charts
helm repo update
helm upgrade --install pet-battle-infra petbattle/pet-battle-infra --version=1.0.9 --set pet-battle-infra-subs.install_cert_util=true --namespace labs-dev
helm upgrade --install pet-battle-tournament petbattle/pet-battle-tournament --version=1.0.10 --set tags.infra=false --namespace labs-dev
helm upgrade --install pet-battle-api petbattle/pet-battle-api --version=1.0.6 --namespace labs-dev
helm upgrade --install pet-battle petbattle/pet-battle --version=1.0.3 --set config_map="'http://$(oc get route -lapp.kubernetes.io/name=pet-battle-api -o custom-columns=ROUTE:.spec.host --no-headers)'"
```

- [ ] FIXME - For now, tag this image
```bash
oc tag quay.io/petbattle/pet-battle-tournament:gha-master labs-dev/pet-battle-tournament:latest
```

## Delete apps

```bash
helm uninstall pet-battle-infra pet-battle-tournament pet-battle-api pet-battle
```
