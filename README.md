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

You will need to adjust the `pet-battle` UI `values.yaml` file to set the backend url's to suit your environment
```bash
wget https://raw.githubusercontent.com/petbattle/pet-battle/master/chart/values.yaml
```

Install the full Pet Battle suite of apps
```bash
helm repo add petbattle https://petbattle.github.io/helm-charts
helm repo update
helm upgrade --install pet-battle-infra petbattle/pet-battle-infra --version=1.0.14 --set install_cert_util=true --namespace labs-dev
helm upgrade --install pet-battle-tournament petbattle/pet-battle-tournament --version=1.0.18 --set tags.infra=false --namespace labs-dev
helm upgrade --install pet-battle-api petbattle/pet-battle-api --version=1.0.8 --namespace labs-dev
helm upgrade --install pet-battle petbattle/pet-battle --version=1.0.4 -f values.yaml
```

- [ ] FIXME - For now, tag this image
```bash
oc tag quay.io/petbattle/pet-battle-tournament:gha-master labs-dev/pet-battle-tournament:latest
```

To install the NSFF feature
```bash
helm upgrade --install pet-battle-nsfw petbattle/pet-battle-nsff --version=0.0.1 --namespace labs-dev
# openshift knative
HOST=$(kn service describe tensorflowserving-pb-nsff -o url)
# openshift deployment
HOST=$(oc get route tensorflowserving-pb-nsff -o custom-columns=ROUTE:.spec.host --no-headers)
helm install pb-api petbattle/pet-battle-api --version=1.0.8 --set nsff.enabled=true --set nsff.apiHost=${HOST}
```

## Delete apps

```bash
helm uninstall pet-battle-infra pet-battle-tournament pet-battle-api pet-battle pet-battle-nsff
```
