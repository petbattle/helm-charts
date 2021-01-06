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
helm install pb-api petbattle/pet-battle-api --version=1.0.4
helm install pb-fe petbattle/pet-battle --version=1.0.3 --set config_map="'http://$(oc get route -lapp.kubernetes.io/name=pet-battle-api -o custom-columns=ROUTE:.spec.host --no-headers)'"
helm install pb-tourny petbattle/pet-battle-tournament --version=1.0.3
```

You can also deploy the Tournament infrastructure separately (this requires cluster admin role)
```bash
helm install pb-infra petbattle/pet-battle-infra --version=1.0.1 --set nameOverride=pet-battle-tournament
```
Then deploy the Tournament service using a normal user
```bash
helm install pb-tourny petbattle/pet-battle-tournament --version=1.0.3 --set tags.infra=false --skip-crds
```

Upgrading a chart version
```bash
helm upgrade pb-api petbattle/pet-battle-api --version 1.0.5
```

## Delete apps

```bash
helm uninstall pb-nsfw pb-api pb-fe pb-tourny pb-infra
oc delete csv cert-utils-operator.v0.2.2 grafana-operator.v3.7.0 infinispan-operator.v2.1.1 keycloak-operator.v11.0.0
```

helm3 will not uninstall crds (be careful, these are cluster wide resources!)
```bash
infr_chart_version=$(helm search repo petbattle/pet-battle-infra | grep petbattle/pet-battle-infra | awk '{print $2}')
helm fetch --untar petbattle/pet-battle-infra --version ${infr_chart_version}
oc delete -f pet-battle-infra/crds
```
