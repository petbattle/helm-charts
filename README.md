# 🍾 petbattle helm charts 🍾
```
helm repo add petbattle https://petbattle.github.io/helm-charts
```

Check for the latest chart versions
```bash
helm search repo pet-battle
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

To install the main Pet Battle applications
```bash
helm upgrade --install pet-battle-tournament petbattle/pet-battle-tournament --version=1.0.20 --namespace petbattle
helm upgrade --install pet-battle-api petbattle/pet-battle-api --version=1.0.8 --namespace petbattle
helm upgrade --install pet-battle petbattle/pet-battle --version=1.0.4 -f values.yaml
```

To install Pet Battle with a separate infrastructure chart useful for debugging
```bash
helm upgrade --install pet-battle-infra petbattle/pet-battle-infra --version=1.0.14 --set install_cert_util=true --namespace petbattle
helm upgrade --install pet-battle-tournament petbattle/pet-battle-tournament --version=1.0.20 --set tags.infra=false --namespace petbattle
helm upgrade --install pet-battle-api petbattle/pet-battle-api --version=1.0.8 --namespace petbattle
helm upgrade --install pet-battle petbattle/pet-battle --version=1.0.4 -f values.yaml
```

To install the NSFF feature
```bash
helm upgrade --install pet-battle-nsff petbattle/pet-battle-nsff --version=0.0.2 --namespace petbattle
# openshift knative
HOST=$(kn service describe tensorflowserving-pb-nsff -o url)
# openshift deployment
HOST=$(oc get route tensorflowserving-pb-nsff -o custom-columns=ROUTE:.spec.host --no-headers)
helm upgrade --install pet-battle-api petbattle/pet-battle-api --version=1.0.8 --set nsff.enabled=true --set nsff.apiHost=${HOST} --namespace petbattle
```

## Delete apps

```bash
helm uninstall pet-battle-infra pet-battle-tournament pet-battle-api pet-battle pet-battle-nsff
```
