layer.zip: Dockerfile
	docker run --rm --entrypoint cat $$(docker build -q .) /tmp/layer.zip > $@

.PHONY: clean
clean:
	rm -f layer.zip
