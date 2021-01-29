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
helm install pb-nsfw petbattle/pet-battle-nsfw --version=0.0.1
helm install pb-api petbattle/pet-battle-api --version=1.0.6
helm install pb-fe petbattle/pet-battle --version=1.0.3 --set config_map="'http://$(oc get route -lapp.kubernetes.io/name=pet-battle-api -o custom-columns=ROUTE:.spec.host --no-headers)'"
helm install pb-tourny petbattle/pet-battle-tournament --version=1.0.9
```

You can also deploy the Tournament infrastructure separately (this requires cluster admin role)
```bash
helm install pb-infra petbattle/pet-battle-infra --version=1.0.8
```
Then deploy the Tournament service using a normal user
```bash
helm install pb-tourny petbattle/pet-battle-tournament --version=1.0.9 --set tags.infra=false
```

Upgrading a chart version
```bash
helm upgrade pb-api petbattle/pet-battle-api --version 1.0.6
```

## Delete apps

```bash
helm uninstall pb-nsfw pb-api pb-fe pb-tourny pb-infra
```
