.PHONY: all
all:  sam-build layer-build

.PHONY: layer-build
layer-build:
	$(MAKE) -C geo_layer
	mkdir -p .aws-sam/build/geo_layer/
	cp geo_layer/layer.zip .aws-sam/build/geo_layer/layer.zip

.PHONY: sam-build
sam-build:
	sam build

.PHONY: deploy
deploy: all
	cfn-cli stack sync

.PHONY: clean
clean:
	rm -rf .aws-sam/build
