REPOSITORY ?= https://petbattle.github.io/helm-charts/ 

helm:
	helm repo index --url $(REPOSITORY) --merge index.yaml .
	git add .
	git commit -m "🦄 updated index 🦄"
	git push
